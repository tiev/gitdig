# frozen_string_literal: true

require 'gitdig/commands/pr/team'

RSpec.describe Gitdig::Commands::Pr::Team do
  it 'executes `pr team TEAM_ID` command successfully' do
    output = StringIO.new
    team_id = 123
    options = {}
    command = Gitdig::Commands::Pr::Team.new(team_id, options)

    search_str = double(String)
    expect(command).to receive(:search_str).and_return(search_str)
    expect(command.github_client).to receive(:search_issues)
      .with(search_str, sort: 'created', order: 'asc', per_page: 100)
      .and_return(double(items: []))

    command.execute(output: output)

    expect(output.string).to eq ''
  end
end
