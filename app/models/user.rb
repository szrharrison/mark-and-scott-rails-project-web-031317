class User < ApplicationRecord
  has_many :pictures
  has_many :categories, through: :pictures
  has_secure_password

  validates :username, presence: true
end
