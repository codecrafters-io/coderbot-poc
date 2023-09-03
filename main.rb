require_relative "boot"

course_slug = ARGV[0]
stage_position = ARGV[1].to_i
repository_dir = ARGV[2]

Store.instance.load_from_file("fixtures/store.json")

course = Store.instance.models_for(Course).detect { |course| course.slug == course_slug }
stages = Store.instance.models_for(CourseStage).select { |stage| stage.course_id == course.id }
stage = stages.detect { |stage| stage.position == stage_position }
local_repository = LocalRepository.new(repository_dir)

pass_stage_workflow = Workflows::PassStageWorkflow.new(
  course: course,
  stage: stage,
  local_repository: local_repository
)

pass_stage_workflow.run

if pass_stage_workflow.error_message
  puts "Error: #{pass_stage_workflow.error_message}"
  exit 1
else
  puts "Success!"
end

logs_file_path = "tmp/workflow_logs/#{course.slug}-#{local_repository.language.slug}-#{stage.position}.html"

FileUtils.mkdir_p(File.dirname(logs_file_path)) unless Dir.exist?(File.dirname(logs_file_path))
File.write(logs_file_path, pass_stage_workflow.html_logs)
