RSpec.describe "`gitdig content put` command", type: :cli do
  it "executes `gitdig content help put` command successfully" do
    output = `gitdig content help put`
    expected_output = <<-OUT
Usage:
  gitdig put PATH

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
