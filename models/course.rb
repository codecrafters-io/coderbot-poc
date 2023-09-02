class Course
  include ActiveModel::Model

  validates_presence_of :id
  validates_presence_of :slug
end