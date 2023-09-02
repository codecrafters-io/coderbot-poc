require_relative "boot"

Store.instance.load_from_file("fixtures/store.json")

course = Store.instance.models_for(Course).detect { |course| course.slug == "bittorrent" }
stages = Store.instance.models_for(CourseStage).select { |stage| stage.course_id == course.id }
first_stage = stages.min_by(&:position)

puts TestPrompt.call(stage: first_stage, course: course).result
