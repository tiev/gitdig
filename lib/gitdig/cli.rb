# frozen_string_literal: true

require 'thor'

module Gitdig
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    class_option :editor, type: :string, lazy_default: 'true',
                          desc: 'Open output in editor'

    desc 'version', 'gitdig version'
    def version
      require_relative 'version'
      puts "v#{Gitdig::VERSION}"
    end
    map %w[--version -v] => :version

    require_relative 'commands/gh_action'
    register Gitdig::Commands::GhAction, 'gh_action', 'gh_action [SUBCOMMAND]', 'Command description...'

    require_relative 'commands/content'
    register Gitdig::Commands::Content, 'content', 'content [SUBCOMMAND]', 'Command description...'

    require_relative 'commands/org'
    register Gitdig::Commands::Org, 'org', 'org [SUBCOMMAND]', 'Search repositories within organization'

    require_relative 'commands/pr'
    register Gitdig::Commands::Pr, 'pr', 'pr [SUBCOMMAND]', 'Command description...'

    require_relative 'commands/config'
    register Gitdig::Commands::Config, 'config', 'config [SUBCOMMAND]', 'Command description...'
  end
end
