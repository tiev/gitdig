# frozen_string_literal: true

RSpec.describe '`gitdig config token` command', type: :cli do
  it 'executes `gitdig config help token` command successfully' do
    output = `./exe/gitdig config help token`
    expected_output = <<~OUT
      Usage:
        gitdig config token TOKEN

      Options:
        -h, [--help], [--no-help]      # Display usage information
        -g, [--global], [--no-global]  # Global configuration

      Set Github personal access token
    OUT

    expect(output).to eq(expected_output)
  end
end
