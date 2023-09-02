class TestRunnerOutput
  attr_accessor :raw_output

  def initialize(raw_output)
    @raw_output = raw_output
  end

  def passed?
    raw_output.include?("All tests ran successfully. Congrats!")
  end

  def last_stage_logs
    raw_output.split("\n\n")[-2]
  end
end
