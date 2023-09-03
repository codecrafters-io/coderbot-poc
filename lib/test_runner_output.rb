class TestRunnerOutput
  attr_accessor :raw_output

  def initialize(raw_output)
    @raw_output = raw_output
  end

  def passed?
    last_stage_logs.gsub(/\e\[(\d+)m/, "").include?("Test passed.")
  end

  def last_stage_logs
    blocks = raw_output.split("\n\n")
    blocks.reverse.find { |block| block.gsub(/\e\[(\d+)m/, "").start_with?("[stage-") }
  end
end
