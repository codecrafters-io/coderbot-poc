class Course
  include ActiveModel::Model

  attr_accessor :id
  attr_accessor :slug

  validates_presence_of :id
  validates_presence_of :slug
end