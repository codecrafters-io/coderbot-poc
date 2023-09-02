require_relative "../boot"

puts "Fetching courses from API"

response = HTTParty.get("https://backend.codecrafters.io/api/v1/courses?include=stages")
parsed_response = JSON.parse(response.body)

courses = parsed_response["data"].map do |course_data|
  Course.new(
    id: course_data["id"],
    slug: course_data["attributes"]["slug"],
    description_markdown: course_data["attributes"]["description-markdown"]
  ).tap(&:validate!)
end

course_stages = parsed_response["included"].map do |stage_data|
  CourseStage.new(
    course_id: stage_data["relationships"]["course"]["data"]["id"],
    description_markdown_template: stage_data["attributes"]["description-markdown-template"],
    id: stage_data["id"],
    position: stage_data["attributes"]["position"],
    slug: stage_data["attributes"]["slug"]
  ).tap(&:validate!)
end

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
