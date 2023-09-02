class CourseStage
  include ActiveModel::Model

  validates_presence_of :course_id
  validates_presence_of :slug
  validates_presence_of :description_markdown_template
end