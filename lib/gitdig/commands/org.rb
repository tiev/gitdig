# frozen_string_literal: true

require 'thor'

module Gitdig
  module Commands
    class Org < Thor

      namespace :org

      desc 'repositories [NAME]', 'Search repositories within organization'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :language, type: :string, desc: 'Filter by language'
      method_option :private, type: :boolean, desc: 'Filter only private'
      method_option :archived, type: :boolean, desc: 'Filter only archived'
      def repositories(name = nil)
        if options[:help]
          invoke :help, ['repositories']
        else
          require_relative 'org/repositories'
          Gitdig::Commands::Org::Repositories.new(name, options).execute
        end
      end
    end
  end
end
