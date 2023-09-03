class Workflows::PassStageWorkflow < Workflows::BaseWorkflow
  attr_accessor :course
  attr_accessor :stage
  attr_accessor :local_repository

  def initialize(course:, stage:, local_repository:)
    super()

    @course = course
    @stage = stage
    @local_repository = local_repository
  end

  def run
    counter = 0

    loop do
      if counter > 10
        self.error_message = "Too many attempts!"
        break
      end

      run_tests_step = Steps::RunTestsStep.new(
        course: course,
        stage: stage,
        local_repository: local_repository
      )

      run_tests_step.perform
      run_tests_step.print_logs_for_console

      steps << run_tests_step

      if run_tests_step.success?
        break
      end

      counter += 1

      puts "-------------------"
      puts "Attempt #{counter}! (Stage ##{stage.position})"
      puts "-------------------"
      puts ""

      attempt_fix_step = Steps::AttemptFixStep.new(
        course: course,
        stage: stage,
        local_repository: local_repository,
        test_runner_output: run_tests_step.test_runner_output
      )

      attempt_fix_step.perform
      attempt_fix_step.print_logs_for_console

      steps << attempt_fix_step
    end
  end
end
