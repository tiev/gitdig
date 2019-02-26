# frozen_string_literal: true

RSpec.describe '`gitdig config org` command', type: :cli do
  it 'executes `gitdig config help org` command successfully' do
    output = `./exe/gitdig config help org`
    expected_output = <<~OUT
      Usage:
        gitdig config org NAME

      Options:
        -h, [--help], [--no-help]      # Display usage information
        -g, [--global], [--no-global]  # Global configuration

      Set your Github organization name
    OUT

    expect(output).to eq(expected_output)
  end
end
