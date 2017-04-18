class User < ApplicationRecord
  has_many :pictures, dependent: :destroy
  has_many :categories, through: :pictures
  has_many :user_leaders
  has_many :leaders, through: :user_leaders
  has_secure_password

  validates :username, presence: true
end
