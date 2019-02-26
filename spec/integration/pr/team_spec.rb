# frozen_string_literal: true

RSpec.describe '`gitdig pr team` command', type: :cli do
  it 'executes `gitdig pr help team` command successfully' do
    output = `./exe/gitdig pr help team`
    expected_output = <<~OUT
      Usage:
        gitdig pr team [TEAM_ID]

      Options:
        -h, [--help], [--no-help]          # Display usage information
        -o, [--organization=ORGANIZATION]  # Within this organization, if missing get configured organization
        -t, [--team=TEAM]                  # Within this team
            [--created=CREATED]            # Filter :created

      Get pull requests created by a team
    OUT

    expect(output).to eq(expected_output)
  end
end
