require_relative "boot"

course_slug = ARGV[0]
stage_slug = ARGV[1]
repository_dir = ARGV[2]

Store.instance.load_from_file("fixtures/store.json")

course = Store.instance.models_for(Course).detect { |course| course.slug == course_slug }
stages = Store.instance.models_for(CourseStage).select { |stage| stage.course_id == course.id }
stage = stages.detect { |stage| stage.slug == stage_slug } || raise "Stage not found for slug #{stage_slug}"
local_repository = LocalRepository.new(repository_dir)

workflow = Workflows::PassStageWorkflow.new(
  course: course,
  stage: stage,
  local_repository: local_repository
)

workflow.run

logs_filename = "#{File.basename(repository_dir)}-#{stage.slug}-#{Time.now.strftime("%Y%m%d%H%M%S")}"

logs_file_path = "tmp/workflow_logs/#{logs_filename}.html"

FileUtils.mkdir_p(File.dirname(logs_file_path)) unless Dir.exist?(File.dirname(logs_file_path))
File.write(logs_file_path, workflow.html_logs)

summary_file_path = "tmp/workflow_logs/#{logs_filename}.md"

FileUtils.mkdir_p(File.dirname(summary_file_path)) unless Dir.exist?(File.dirname(summary_file_path))
File.write(summary_file_path, workflow.summary_markdown)

if workflow.error_message
  puts "Error: #{workflow.error_message}"
  exit 1
else
  puts "Success!"
end
