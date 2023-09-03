require_relative "boot"

course_slug = ARGV[0]
repository_dir = ARGV[1]

Store.instance.load_from_file("fixtures/store.json")

course = Store.instance.models_for(Course).detect { |course| course.slug == course_slug }
stages = Store.instance.models_for(CourseStage).select { |stage| stage.course_id == course.id }
local_repository = LocalRepository.new(repository_dir)

workflow = Workflows::PassMultipleStagesWorkflow.new(
  course: course,
  stages: stages.sort_by(&:position).first(3),
  local_repository: local_repository
)

workflow.run

logs_file_path = "tmp/workflow_logs/#{course.slug}-#{local_repository.language.slug}.html"

FileUtils.mkdir_p(File.dirname(logs_file_path)) unless Dir.exist?(File.dirname(logs_file_path))
File.write(logs_file_path, workflow.html_logs)

if workflow.error_message
  puts "Error: #{workflow.error_message}"
  exit 1
else
  puts "Success!"
end
