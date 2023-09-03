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
  current_code = File.read(local_repository.code_file_path)
  test_runner_output = LocalTestRunner.new(course, repository_dir).run_tests(stage)

  if test_runner_output.passed?
    puts ""
    puts "Logs:"
    puts ""

    puts test_runner_output.last_stage_logs

    puts ""
    puts "All tests passed!"
    break
  end

  counter += 1

  puts "-------------------"
  puts "Attempt #{counter}!"
  puts "-------------------"
  puts ""

  puts "Logs:"
  puts ""

  puts test_runner_output.last_stage_logs

  result = TestPrompt.call(
    stage: stage,
    course: course,
    original_code: current_code,
    test_runner_output: test_runner_output
  ).result

  edited_code = result.scan(/```#{local_repository.language.syntax_highlighting_identifier}\n(.*?)```/m).join("\n")

  puts "Diff:"
  puts ""

  Diffy::Diff.default_format = :color
  puts Diffy::Diff.new(current_code, edited_code, context: 2)

  File.write(local_repository.code_file_path, edited_code)
end
