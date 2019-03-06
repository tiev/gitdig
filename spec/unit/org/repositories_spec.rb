require 'gitdig/commands/org/repositories'

RSpec.describe Gitdig::Commands::Org::Repositories do
  it "executes `org repositories` command successfully" do
    output = StringIO.new
    name = nil
    options = {}
    command = Gitdig::Commands::Org::Repositories.new(name, options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
