RSpec.describe "`gitdig gh_action installation` command", type: :cli do
  it "executes `gitdig gh_action help installation` command successfully" do
    output = `gitdig gh_action help installation`
    expected_output = <<-OUT
Usage:
  gitdig installation REPOSITORY ACTION_NAME

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
