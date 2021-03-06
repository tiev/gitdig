# frozen_string_literal: true

require_relative '../../command'
require_relative '../org/repositories'
require_relative '../content/put'
require_relative 'installation'

module Gitdig
  module Commands
    class GhAction
      class Install < Gitdig::Command
        attr_reader :my_prompt

        def initialize(action_name, code_path, options)
          @action_name = action_name
          @code_path = code_path
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          @my_prompt = prompt(input: input, output: output)

          collect_input

          interactive_menu
        end

        private

        def interactive_menu
          loop do
            cmd = my_prompt.enum_select('Commands:', %i[status install quit])
            case cmd
            when :status
              check_status
            when :install
              install
            end
            break if cmd == :quit
          end
        end

        def check_status
          kind = my_prompt.enum_select('Check status?', %i[individuals all])
          do_check_status(kind)
        end

        def do_check_status(kind)
          targets = if kind == :all
                      repo_list.map { |choice| choice[:value] }
                    else
                      my_prompt.multi_select(
                        "Check installation of #{@action_name} on",
                        repo_list,
                        filter: true
                      )
                    end

          targets.each do |repository|
            update_status(repository)
          end
        end

        def update_status(repository)
          installation = Installation.new(repository, @action_name, {}).execute
          status = status_of(installation)

          name = "#{repository} (#{status})"
          replace_in_lists(name, repository, status)

          installation[:active] ? my_prompt.ok(name) : my_prompt.warn(name)
        end

        def replace_in_lists(name, value, status)
          repo_choice = { name: name, value: value }
          target_choice = repo_choice.dup
          target_choice[:disabled] = '(branch exists)' if status == 'branch'
          repo_list.map! do |choice|
            choice[:value] == value ? repo_choice : choice
          end
          target_list.map! do |choice|
            choice[:value] == value ? target_choice : choice
          end
        end

        def install
          kind = ask_install_kind
          targets = targets_of_kind(kind)
          return if targets.empty?

          collect_pr_options
          process_targets(targets)
        end

        def ask_install_kind
          my_prompt.enum_select('Install on which?') do |menu|
            menu.default 2

            menu.choice 'All', :all
            menu.choice 'Individuals', :individuals
            menu.choice 'Not installed yet', :off
            menu.choice 'Installed ones', :on
          end
        end

        def targets_of_kind(kind)
          case kind
          when :all
            target_list.map { |choice| choice[:value] unless choice[:disabled] }.compact
          when :off, :on
            do_check_status(:all)
            target_list.map do |choice|
              choice[:value] if choice[:name].end_with?("(#{kind})")
            end.compact
          else
            my_prompt.multi_select(
              "Install #{@action_name} on", target_list,
              filter: true
            )
          end
        end

        def process_targets(targets)
          targets.map do |repository|
            Content::Put.new(repository, @code_path, pr_options).execute
          rescue StandardError => ex
            my_prompt.error("[#{repository}] #{ex.inspect}")
            my_prompt.error(ex.backtrace.join("\n"))
            nil
          end.compact
        end

        def repo_list
          @repo_list ||= repositories.map { |repository| { name: repository, value: repository } }
        end

        def target_list
          @target_list ||= repo_list.dup
        end

        def repositories
          @repositories ||= Org::Repositories.new(
            @user_input[:org],
            @user_input[:repo_filters].compact
          ).execute.map(&:full_name).sort
        end

        def collect_input
          optional_yes_no = [
            { key: 'y', name: 'Yes', value: true },
            { key: 'n', name: 'No', value: false },
            { key: 'a', name: 'All', value: nil }
          ]
          org = configs.fetch(:org)
          @user_input = my_prompt.collect do
            key(:org).ask('Organization?', default: org, required: true)
            say('Repository filters:')
            key(:repo_filters) do
              key(:language).ask(' - Languages?', default: nil)
              key(:private).expand(' - Private?', optional_yes_no, default: 1)
              key(:archived).expand(' - Archived?', optional_yes_no, default: 2)
            end
          end
        end

        def pr_options
          @pr_options ||= @pr_input&.merge(branch: @action_name.downcase.gsub(/\s/, '-'))
        end

        def collect_pr_options
          @pr_input = my_prompt.collect do
            key(:message).ask('Pull request title?', required: true)
          end
        end

        def status_of(installation)
          if installation[:active]
            'on'
          elsif installation[:branch]
            'branch'
          else
            'off'
          end
        end
      end
    end
  end
end
