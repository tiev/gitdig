# frozen_string_literal: true

require_relative '../../command'

module Gitdig
  module Commands
    class Pr
      class Team < Gitdig::Command
        REPO_REGEX = %r{[^/]+/[^/]+$}.freeze

        def initialize(team_id, options)
          @team_id = team_id
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          issues = github_client.search_issues(
            search_str,
            sort: 'created', order: 'asc', per_page: 100
          )
          issues.items.each do |i|
            output.puts pr_output(i)
          end
        end

        private

        def team
          @team = @team_id || prompt.select('Choose a team to get pull requests') do |menu|
            teams.each { |t| menu.choice "#{t.name} (#{t.id})", t.id }
          end
        end

        def search_str
          @search_str ||=
            begin
              author_str = members(team).map { |mem| "author:#{mem.login}" }.join(' ')
              search_str = "type:pr #{author_str}"
              search_str = "#{search_str} created:#{@options[:created]}" if @options[:created]
              search_str = "#{search_str} org:#{org}" if org

              search_str
            end
        end

        def org
          @org ||= @options[:organization] || configs.fetch(:org)
        end

        def teams
          @teams ||= if @options[:team]
                       github_client.child_teams(@options[:team])
                     elsif @options[:organization]
                       github_client.organization_teams(@options[:organization])
                     elsif (org = configs.fetch(:org))
                       github_client.organization_teams(org)
                     end
        end

        def members(team_id)
          github_client.team_members(team_id)
        end

        def pr_output(pull)
          repo = REPO_REGEX.match(pull.repository_url).to_s
          "* [#{pull.title}](#{pull.html_url}) <#{pull.state}>"\
            " #{repo}##{pull.number} @#{pull.user.login}"
        end
      end
    end
  end
end
