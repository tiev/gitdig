# frozen_string_literal: true

require_relative '../../command'
require 'tmpdir'

module Gitdig
  module Commands
    class Content
      class Put < Gitdig::Command
        require 'tty-pager'

        attr_reader :my_prompt, :my_pager

        def initialize(repository, path, options)
          @repository = repository
          @path = path
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          @my_prompt = prompt(input: input, output: output)
          @my_pager = TTY::Pager::BasicPager.new(input: input, output: output)
          pr = nil

          Dir.mktmpdir do |dir|
            unless copy_content(@path, dir)
              my_prompt.error('Given path is not file nor directory!')
              break
            end

            prepare_content(dir)
            pr = create_pr(dir)
            my_prompt.ok("Pull Request: #{pr.html_url}") if pr
          end

          pr
        end

        private

        def create_pr(dir) # rubocop:disable Metrics/AbcSize
          return unless my_prompt.yes?("Create PR on #{@repository}?")

          tree = github_client.create_tree(
            @repository,
            file_objects(dir),
            base_tree: default_branch.commit.sha
          )
          commit = github_client.create_commit(
            @repository, @options[:message],
            tree.sha, default_branch.commit.sha
          )
          head = "refs/heads/gitdig/put-#{@options[:branch] || Time.now.to_i}"
          github_client.create_ref(@repository, head, commit.sha)

          github_client.create_pull_request(
            @repository, default_branch.name, head, @options[:message]
          )
        end

        def repository_obj
          @repository_obj ||= github_client.repository(@repository)
        end

        def default_branch
          @default_branch ||= github_client.branch(@repository, repository_obj.default_branch)
        end

        def file_objects(dir)
          Dir.glob('**/*', File::FNM_DOTMATCH, base: dir).map do |file|
            full_path = File.join(dir, file)
            next unless File.file?(full_path)

            {
              path: file,
              mode: '100644',
              type: 'blob',
              content: File.read(full_path)
            }
          end.compact
        end

        def prepare_content(dir)
          my_prompt.say("***Repository #{@repository}***")
          Dir.glob('**/*', File::FNM_DOTMATCH, base: dir) do |file|
            full_path = File.join(dir, file)
            next unless File.file?(full_path)

            remote_file = get_remote_file(file)
            diff = diff_remote_file(file, full_path, remote_file)
            next unless diff

            solve_file(file, full_path, remote_file, diff)
          end
        end

        def diff_remote_file(file, full_path, remote_file)
          if remote_file.nil?
            my_prompt.say("New file: #{file}")
            return nil
          end

          diff = diff_of(remote_file, full_path)
          if diff.empty?
            my_prompt.say("Identical file: #{file}")
            return nil
          end

          diff
        end

        def solve_file(file, full_path, remote_file, diff)
          loop do
            choice = prompt_file_choice(file)
            case choice
            when :no
              File.open(full_path, 'w') { |f| f.write(remote_file) }
            when :diff
              my_pager.page(diff)
            when :edit
              open_file_to_merge(full_path, remote_file)
            end
            break if choice != :diff
          end
        end

        def prompt_file_choice(file)
          my_prompt.expand("Overwrite #{file}?") do |q|
            q.choice key: 'y', name: 'Overwrite', value: :ok
            q.choice key: 'n', name: 'Skip', value: :no
            # q.choice key: 'a', name: 'Overwrite all', value: :all
            q.choice key: 'd', name: 'Show diff', value: :diff
            q.choice key: 'e', name: 'Edit merge', value: :edit
            # q.choice key: 'q', name: 'Quit', value: :quit
          end
        end

        def diff_of(source, dest)
          generator.diff_files(source, dest, verbose: false)
        end

        def open_file_to_merge(file, content)
          generator.prepend_to_file(file, verbose: false) do
            <<-CONTENT.gsub(/^\s+\|/, '')
            |<<<<<<< Repository file
            |#{content}
            |=======
            CONTENT
          end
          generator.append_to_file(file, '>>>>>>> Local file', verbose: false)
          editor.open(file)
        end

        def copy_content(path, target)
          if File.directory?(path)
            generator.copy_directory(path, target, verbose: false)
          elsif File.file?(path)
            generator.copy_file(path, target, verbose: false)
          else
            return false
          end

          true
        end

        def get_remote_file(file)
          github_client.content(@repository, path: file, accept: 'application/vnd.github.v3.raw')
        rescue Octokit::NotFound
          nil
        end
      end
    end
  end
end
