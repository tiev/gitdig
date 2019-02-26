# frozen_string_literal: true

RSpec.describe '`gitdig config` command', type: :cli do
  it 'executes `gitdig help config` command successfully' do
    output = `./exe/gitdig help config`

    expect(output).to include('gitdig config help [COMMAND]')
    expect(output).to include('gitdig config org NAME')
    expect(output).to include('gitdig config token TOKEN')
    expect(output).to include('-g')
  end
end
