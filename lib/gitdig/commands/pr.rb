# frozen_string_literal: true

require 'thor'

module Gitdig
  module Commands
    class Pr < Thor
      require_relative 'mixin/editorable'
      include Mixin::Editorable

      namespace :pr

      class_option :created, type: :string, desc: 'Filter :created'

      desc 'team [TEAM_ID]', 'Get pull requests created by a team'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :organization,
                    aliases: '-o', type: :string,
                    desc: 'Within this organization, if missing get configured organization'
      method_option :team, aliases: '-t', type: :string,
                           desc: 'Within this team'
      def team(team_id = nil)
        if options[:help]
          invoke :help, ['team']
        else
          require_relative 'pr/team'
          editor_exec(Gitdig::Commands::Pr::Team.new(team_id, options))
        end
      end
    end
  end
end
