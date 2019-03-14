require 'gitdig/commands/content/put'

RSpec.describe Gitdig::Commands::Content::Put do
  it "executes `content put` command successfully" do
    output = StringIO.new
    path = nil
    options = {}
    command = Gitdig::Commands::Content::Put.new(path, options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
