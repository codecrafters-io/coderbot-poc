class Steps::RunTestsStep
  attr_accessor :course
  attr_accessor :local_repository
  attr_accessor :stage

  attr_accessor :test_runner_output

  def initialize(course:, stage:, local_repository:)
    @course = course
    @stage = stage
    @local_repository = local_repository
  end

  def html_logs
    <<~HTML
      <div>
        <h2>Run tests</h2>
        <pre><code>#{test_runner_output.last_stage_logs_without_colors}</code></pre>
      </div>
    HTML
  end

  def perform
    self.test_runner_output = LocalTestRunner.new(course, local_repository.repository_dir).run_tests(stage)
  end

  def print_logs_for_console
    puts "Logs:"
    puts ""
    puts test_runner_output.last_stage_logs
    puts ""

    if test_runner_output.passed?
      puts "All tests passed!"
    end
  end

  def success?
    test_runner_output.passed?
  end
end
