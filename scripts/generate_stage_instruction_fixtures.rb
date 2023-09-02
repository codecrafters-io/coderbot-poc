require_relative "../boot"

puts "Fetching courses from API"

response = HTTParty.get("https://backend.codecrafters.io/api/v1/courses?include=stages")
parsed_response = JSON.parse(response.body)

courses = parsed_response["data"].map do |course_data|
  Course.new(id: course_data["id"], slug: course_data["attributes"]["slug"])
end

puts courses
