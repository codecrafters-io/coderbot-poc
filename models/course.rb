class Course
  include ActiveModel::Model

  attr_accessor :id
  attr_accessor :slug
  attr_accessor :description_markdown

  validates_presence_of :id
  validates_presence_of :slug
  validates_presence_of :description_markdown
end