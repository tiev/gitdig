# frozen_string_literal: true

require_relative '../../command'

module Gitdig
  module Commands
    class Config
      class Token < Gitdig::Command
        def initialize(my_token, options)
          @my_token = my_token
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          configs.set(:token, value: @my_token)
          configs.write(force: true)
          output.puts 'OK'
        end
      end
    end
  end
end
