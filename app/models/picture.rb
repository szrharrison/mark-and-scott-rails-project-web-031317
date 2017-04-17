class Picture < ApplicationRecord
  mount_uploader :image, ImageUploader
  has_many :picture_categories
  has_many :categories, through: :picture_categories
  belongs_to :user

  validates :user_id, presence: true
  validates :image, presence: true
end
