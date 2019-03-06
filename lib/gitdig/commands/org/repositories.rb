# frozen_string_literal: true

require_relative '../../command'

module Gitdig
  module Commands
    class Org
      class Repositories < Gitdig::Command
        def initialize(name, options)
          @name = name
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          repos = github_client.search_repositories(
            search_str,
            sort: 'updated', order: 'desc', per_page: 100
          )
          output.puts "Found #{repos.items.count}"
          repos.items.each do |repo|
            output.puts repo.full_name
          end
        end

        private

        def search_str
          @search_str ||=
            begin
              search_str = "org:#{@name || configs.fetch(:org)}"
              search_str = "#{search_str} language:#{@options[:language]}" if @options[:language]
              search_str = "#{search_str} is:private" if @options[:private]
              unless @options[:archived].nil?
                search_str = "#{search_str} archived:#{@options[:archived]}"
              end

              search_str
            end
        end
      end
    end
  end
end
