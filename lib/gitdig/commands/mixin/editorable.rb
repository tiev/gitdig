# frozen_string_literal: true

module Gitdig
  module Commands
    module Mixin
      module Editorable
        OUTPUT_FILE = File.expand_path('.gitdig_output.md', Dir.home)

        def editor_exec(command)
          if options[:editor]
            out = StringIO.new
            command.execute(output: out)
            opts = { content: out.string }
            opts[:command] = options[:editor] if options[:editor] != 'true'
            open_editor(command, opts)
          else
            command.execute
          end
        end

        def open_editor(command, opts)
          command.generator.remove_file OUTPUT_FILE, verbose: false
          command.editor.open(OUTPUT_FILE, opts)
        end
      end
    end
  end
end
