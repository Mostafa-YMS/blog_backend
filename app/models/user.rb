class User < ApplicationRecord
    has_one_attached :image
    has_secure_password
    validates :email, uniqueness: true
    validates_presence_of :name
    validates_presence_of :email
end
