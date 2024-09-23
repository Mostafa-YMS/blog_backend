class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  validates :author, presence: true
  has_many :tags
  has_many :comments
end
