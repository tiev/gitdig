RSpec.describe "`gitdig org repositories` command", type: :cli do
  it "executes `gitdig org help repositories` command successfully" do
    output = `gitdig org help repositories`
    expected_output = <<-OUT
Usage:
  gitdig repositories [NAME]

Options:
  -h, [--help], [--no-help]  # Display usage information

Search repositories within organization
    OUT

    expect(output).to eq(expected_output)
  end
end
