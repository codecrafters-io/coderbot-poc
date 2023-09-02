class Store
  include Singleton

  def self.model_classes
    [
      Course,
      CourseStage
    ]
  end

  def initialize
    @models_map = self.class.model_classes.map { |model_class| [model_class, {}] }.to_h
  end

  def add(model)
    @models_map[model.class][model.id] = model
  end

  def fetch_all
    response = HTTParty.get("https://backend.codecrafters.io/api/v1/courses?include=stages")
    parsed_response = JSON.parse(response.body)

    courses = parsed_response["data"].map do |course_data|
      Course.new(
        id: course_data["id"],
        slug: course_data["attributes"]["slug"],
        description_markdown: course_data["attributes"]["description-markdown"]
      ).tap(&:validate!)
    end

    courses.each do |course|
      add(course)
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

    course_stages.each do |course_stage|
      add(course_stage)
    end
  end

  def models_for(model_class)
    @models_map[model_class].values
  end
end
