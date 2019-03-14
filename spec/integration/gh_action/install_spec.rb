RSpec.describe "`gitdig gh_action install` command", type: :cli do
  it "executes `gitdig gh_action help install` command successfully" do
    output = `gitdig gh_action help install`
    expected_output = <<-OUT
Usage:
  gitdig install

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
