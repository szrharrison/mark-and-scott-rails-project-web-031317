class User < ApplicationRecord
  has_many :pictures, dependent: :destroy
  has_many :categories, -> { distinct }, through: :pictures
  has_many :user_leaders, dependent: :destroy
  has_many :leaders, -> { distinct }, through: :user_leaders
  has_many :favorites, foreign_key: "favorited_by_id", dependent: :destroy
  has_many :favorite_pictures, -> { distinct }, through: :favorites
  has_secure_password

  validates :username, presence: true
end
