require_relative "boot"

Store.instance.load_from_file("fixtures/store.json")

course = Store.instance.models_for(Course).detect { |course| course.slug == "bittorrent" }
stages = Store.instance.models_for(CourseStage).select { |stage| stage.course_id == course.id }
first_stage = stages.min_by(&:position)

counter = 0

loop do
  current_code = File.read("current_repository/app/main.py")
  test_runner_output = TestRunner.new("current_repository").run_tests

  break if test_runner_output.passed?

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

  File.write("current_repository/app/main.py", edited_code)
end
