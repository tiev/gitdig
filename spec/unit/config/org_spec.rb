# frozen_string_literal: true

require 'gitdig/commands/config/org'

RSpec.describe Gitdig::Commands::Config::Org do
  it 'executes `config org` command successfully' do
    output = StringIO.new
    name = 'org'
    command = Gitdig::Commands::Config::Org.new(name, {})

    expect(command.configs).to receive(:set)
      .with(:org, value: name).and_call_original
    expect(command.configs).to receive(:write)
      .with(force: true)

    command.execute(output: output)

    expect(command.configs.fetch(:org)).to eq name
    expect(output.string).to eq("OK\n")
  end
end
