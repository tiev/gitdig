require 'gitdig/commands/gh_action/installation'

RSpec.describe Gitdig::Commands::GhAction::Installation do
  it "executes `gh_action installation` command successfully" do
    output = StringIO.new
    repository = nil
    action_name = nil
    options = {}
    command = Gitdig::Commands::GhAction::Installation.new(repository, action_name, options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
