# frozen_string_literal: true

require 'thor'

module Gitdig
  module Commands
    class Content < Thor
      namespace :content

      desc 'put REPOSITORY PATH', 'Create PR to put directory/file content to a repository'
      method_option :message, aliases: '-m', type: :string, required: true,
                              desc: 'Set the commit and pull request message'
      method_option :branch, aliases: '-b', type: :string,
                             desc: 'Set the branch suffix for the pull request'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def put(repository, path)
        if options[:help]
          invoke :help, ['put']
        else
          require_relative 'content/put'
          Gitdig::Commands::Content::Put.new(repository, path, options).execute
        end
      end
    end
  end
end
