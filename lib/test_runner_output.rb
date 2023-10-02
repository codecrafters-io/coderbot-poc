class TestRunnerOutput
  attr_accessor :test_script_result

  def initialize(test_script_result)
    @test_script_result = test_script_result
  end

  def compilation_failed?
    last_stage_logs.nil? # Assume that compilation failed if there are no stage logs
  end

  def raw_output
    test_script_result.stdout + test_script_result.stderr
  end

  def passed?
    !compilation_failed? && last_stage_logs.gsub(/\e\[(\d+)m/, "").include?("Test passed.")
  end

  def last_stage_logs
    blocks = test_script_result.stdout.split("\n\n")
    blocks.reverse.find { |block| block.gsub(/\e\[(\d+)m/, "").start_with?("[stage-") }
  end

  def last_stage_logs_without_colors
    last_stage_logs.gsub(/\e\[(\d+)m/, "")
  end
end
