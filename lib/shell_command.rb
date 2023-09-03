class ShellCommand
  attr_accessor :command

  def initialize(command)
    @command = command
  end

  def run(stream_output: false)
    _, stdout_io, stderr_io, wait_thr = Open3.popen3(command)

    puts ""

    stdout_captured, stderr_captured = StringIO.new, StringIO.new

    if stream_output
      setup_io_relay(stdout_io, $stdout, stdout_captured)
      setup_io_relay(stderr_io, $stderr, stderr_captured)
    else
      setup_io_relay(stdout_io, File.open(File::NULL, "w"), stdout_captured)
      setup_io_relay(stderr_io, File.open(File::NULL, "w"), stderr_captured)
    end

    exit_code = wait_thr.value.exitstatus
    stdout, stderr = stdout_captured.string, stderr_captured.string

    ShellCommandResult.new(exit_code, stdout, stderr)
  end

  def run!
    result = run

    raise <<~ERROR if result.failure?
      Command failed: #{command}. Exit code: #{result.exit_code}
    ERROR

    result
  end

  protected

  def setup_io_relay(source, prefixed_destination, other_destination)
    IO.copy_stream(
      source,
      MultiWriter.new(
        PrefixedLineWriter.new("     ", prefixed_destination),
        other_destination
      )
    )
  end
end
