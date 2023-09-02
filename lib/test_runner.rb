class TestRunner
  attr_accessor :repository_dir

  def initialize(repository_dir)
    @repository_dir = repository_dir
  end

  def run_tests
    Dir.chdir(@repository_dir) do
      output = `codecrafters test`
      exit_code = $?.exitstatus
      raise "Failed to run tests" unless exit_code == 0
      TestRunnerOutput.new(output)
    end
  end
end
