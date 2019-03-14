# frozen_string_literal: true

require 'thor'

module Gitdig
  module Commands
    class GhAction < Thor

      namespace :gh_action

      desc 'installation REPOSITORY ACTION_NAME', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def installation(repository, action_name)
        if options[:help]
          invoke :help, ['installation']
        else
          require_relative 'gh_action/installation'
          Gitdig::Commands::GhAction::Installation.new(repository, action_name, options).execute
        end
      end

      desc 'install ACTION_NAME CODE_PATH', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def install(action_name, code_path)
        if options[:help]
          invoke :help, ['install']
        else
          require_relative 'gh_action/install'
          Gitdig::Commands::GhAction::Install.new(action_name, code_path, options).execute
        end
      end
    end
  end
end
