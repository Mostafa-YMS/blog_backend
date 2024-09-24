class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  validates :author, presence: true
  has_many :tags, dependent: :delete_all
  has_many :comments, dependent: :delete_all
end
