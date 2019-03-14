require 'gitdig/commands/gh_action/install'

RSpec.describe Gitdig::Commands::GhAction::Install do
  it "executes `gh_action install` command successfully" do
    output = StringIO.new
    options = {}
    command = Gitdig::Commands::Action::Install.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
