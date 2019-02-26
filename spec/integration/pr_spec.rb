# frozen_string_literal: true

RSpec.describe '`gitdig pr` command', type: :cli do
  it 'executes `gitdig help pr` command successfully' do
    output = `./exe/gitdig help pr`

    expect(output).to include('gitdig pr help [COMMAND]')
    expect(output).to include('gitdig pr team [TEAM_ID]')
    expect(output).to include('[--created=CREATED]')
  end
end
