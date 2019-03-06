RSpec.describe "`gitdig org` command", type: :cli do
  it "executes `gitdig help org` command successfully" do
    output = `gitdig help org`
    expected_output = <<-OUT
Commands:
    OUT

    expect(output).to eq(expected_output)
  end
end
