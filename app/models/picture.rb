class Picture < ApplicationRecord
  # mount_uploader :image, ImageUploader
  has_many :picture_categories
  has_many :categories, through: :picture_categories
  belongs_to :user

  validates :user_id, presence: true
  validates :image_url, presence: true

  def non_category
    Category.all - categories
  end
end