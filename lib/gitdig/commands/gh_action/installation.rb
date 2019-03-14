# frozen_string_literal: true

require_relative '../../command'

module Gitdig
  module Commands
    class GhAction
      class Installation < Gitdig::Command
        def initialize(repository, action_name, options)
          @repository = repository
          @action_name = action_name
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          existed = workflow_file.match?(/^\s*action\s+\"#{@action_name}\"/)
          {
            active: existed,
            branch: put_branch
          }
        end

        private

        def workflow_file
          @workflow_file ||=
            begin
              github_client.content(
                @repository,
                path: '.github/main.workflow',
                accept: 'application/vnd.github.v3.raw'
              )
            rescue Octokit::NotFound
              ''
            end
        end

        def put_branch
          @put_branch ||=
            begin
              github_client.branch(@repository, put_branch_name)
            rescue Octokit::NotFound
              nil
            end
        end

        def put_branch_name
          @put_branch_name ||= "gitdig/put-#{@action_name.downcase.gsub(/\s/, '-')}"
        end
      end
    end
  end
end
