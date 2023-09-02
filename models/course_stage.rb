class CourseStage
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :id
  attr_accessor :course_id
  attr_accessor :slug
  attr_accessor :description_markdown_template
  attr_accessor :position
  attr_accessor :name

  validates_presence_of :id
  validates_presence_of :course_id
  validates_presence_of :slug
  validates_presence_of :description_markdown_template
  validates_presence_of :position
  validates_presence_of :name

  def attributes
    {
      "id" => nil,
      "course_id" => nil,
      "slug" => nil,
      "description_markdown_template" => nil,
      "position" => nil,
      "name" => nil
    }
  end
end
