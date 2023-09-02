require_relative "../boot"

puts "Fetching courses from API"

Store.instance.fetch_all
Store.instance.persist("fixtures/store.json")

Store.instance.clear

courses = Store.instance.models_for(Course)
course_stages = Store.instance.models_for(CourseStage)

courses.each do |course|
  puts "Generating fixtures for course #{course.slug}"

  FileUtils.mkdir_p("fixtures/#{course.slug}/stage_instructions") unless Dir.exist?("fixtures/#{course.slug}/stage_instructions")
  File.write("fixtures/#{course.slug}/description.md", course.description_markdown)

  course_stages.each do |course_stage|
    next unless course_stage.course_id == course.id

    puts "- Generating fixtures for stage ##{course_stage.position}"
    File.write("fixtures/#{course.slug}/stage_instructions/#{course_stage.position}.md", course_stage.description_markdown_template)
  end
end
