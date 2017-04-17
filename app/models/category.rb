class Category < ApplicationRecord
  has_many :picture_categories
  has_many :pictures, through: :picture_categories

  validates :name, presence: true
end
