RSpec.describe "`gitdig content` command", type: :cli do
  it "executes `gitdig help content` command successfully" do
    output = `gitdig help content`
    expected_output = <<-OUT
Commands:
    OUT

    expect(output).to eq(expected_output)
  end
end
