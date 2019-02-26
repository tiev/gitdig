# frozen_string_literal: true

require 'thor'

module Gitdig
  module Commands
    class Config < Thor
      namespace :config

      class_option :global, aliases: '-g', type: :boolean,
                            desc: 'Global configuration'

      desc 'token TOKEN', 'Set Github personal access token'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def token(token)
        if options[:help]
          invoke :help, ['token']
        else
          require_relative 'config/token'
          command = Gitdig::Commands::Config::Token.new(token, options)
          ensure_scope(command).execute
        end
      end

      desc 'org NAME', 'Set your Github organization name'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def org(name)
        if options[:help]
          invoke :help, ['org']
        else
          require_relative 'config/org'
          command = Gitdig::Commands::Config::Org.new(name, options)
          ensure_scope(command).execute
        end
      end

      private

      def ensure_scope(command)
        command.configs.prepend_path Dir.home if options[:global]

        command
      end
    end
  end
end
