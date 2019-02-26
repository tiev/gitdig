# frozen_string_literal: true

require 'gitdig/commands/config/token'

RSpec.describe Gitdig::Commands::Config::Token do
  it 'executes `config token` command successfully' do
    output = StringIO.new
    my_token = 'abc'
    command = Gitdig::Commands::Config::Token.new(my_token, {})

    expect(command.configs).to receive(:set)
      .with(:token, value: my_token).and_call_original
    expect(command.configs).to receive(:write)
      .with(force: true)

    command.execute(output: output)

    expect(command.configs.fetch(:token)).to eq my_token
    expect(output.string).to eq("OK\n")
  end
end
