require_relative "boot"

course_slug = ARGV[0]
stage_position = ARGV[1].to_i
repository_dir = ARGV[2]

Store.instance.load_from_file("fixtures/store.json")

course = Store.instance.models_for(Course).detect { |course| course.slug == course_slug }
stages = Store.instance.models_for(CourseStage).select { |stage| stage.course_id == course.id }
stage = stages.detect { |stage| stage.position == stage_position }
local_repository = LocalRepository.new(repository_dir)

counter = 0

loop do
  if counter > 10
    raise "Too many attempts!"
  end

  run_tests_step = Steps::RunTestsStep.new(
    course: course,
    stage: stage,
    local_repository: local_repository
  )

  run_tests_step.perform
  run_tests_step.print_logs_for_console

  if run_tests_step.success?
    break
  end

  counter += 1

  puts "-------------------"
  puts "Attempt #{counter}!"
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
end
