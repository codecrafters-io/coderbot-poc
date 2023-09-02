class Course
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :id
  attr_accessor :slug
  attr_accessor :description_markdown

  validates_presence_of :id
  validates_presence_of :slug
  validates_presence_of :description_markdown

  def attributes
    {
      "id" => nil,
      "slug" => nil,
      "description_markdown" => nil
    }
  end
end
