RSpec.describe "`gitdig gh_action` command", type: :cli do
  it "executes `gitdig help gh_action` command successfully" do
    output = `gitdig help gh_action`
    expected_output = <<-OUT
Commands:
    OUT

    expect(output).to eq(expected_output)
  end
end
