require_relative "boot"

course_slug = ARGV[0]
stage_position = ARGV[1].to_i
repository_dir = ARGV[2]

Store.instance.load_from_file("fixtures/store.json")

course = Store.instance.models_for(Course).detect { |course| course.slug == course_slug }
stages = Store.instance.models_for(CourseStage).select { |stage| stage.course_id == course.id }
first_stage = stages.detect { |stage| stage.position == stage_position }

tester_dir = TesterDownloader.new(course).download_if_needed

counter = 0

exit 1

loop do
  current_code = File.read("#{repository_dir}/app/main.py")
  test_runner_output = TestRunner.new(repository_dir).run_tests

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
    stage: first_stage,
    course: course,
    original_code: current_code,
    test_runner_output: test_runner_output
  ).result

  edited_code = result.scan(/```python\n(.*?)```/m).join("\n")

  puts "Diff:"
  puts ""

  Diffy::Diff.default_format = :color
  puts Diffy::Diff.new(current_code, edited_code, context: 2)

  File.write("#{repository_dir}/app/main.py", edited_code)
end
