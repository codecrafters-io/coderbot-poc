require_relative "boot"

Store.instance.load_from_file("fixtures/store.json")

course = Store.instance.models_for(Course).detect { |course| course.slug == "bittorrent" }
stages = Store.instance.models_for(CourseStage).select { |stage| stage.course_id == course.id }
first_stage = stages.min_by(&:position)

original_code = File.read("current_repository/app/main.py")

test_runner_output = TestRunner.new("current_repository").run_tests

result = TestPrompt.call(
  stage: first_stage,
  course: course,
  original_code: original_code,
  test_runner_output: test_runner_output
).result

puts result
extracted_code = result.scan(/```python\n(.*?)```/m).join("\n")

puts "Diff:"
puts ""
puts ""

Diffy::Diff.default_format = :color
puts Diffy::Diff.new(original_code, extracted_code, context: 2)

File.write("current_repository/app/main.py", extracted_code)
test_runner_output = TestRunner.new("current_repository").run_tests

puts "Passed: #{test_runner_output.passed?}"
puts test_runner_output.last_stage_logs
