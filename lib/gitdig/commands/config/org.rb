# frozen_string_literal: true

require_relative '../../command'

module Gitdig
  module Commands
    class Config
      class Org < Gitdig::Command
        def initialize(name, options)
          @name = name
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          configs.set(:org, value: @name)
          configs.write(force: true)
          output.puts 'OK'
        end
      end
    end
  end
end
