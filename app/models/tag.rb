class Tag < ApplicationRecord
  has_many :picture_tags
  has_many :pictures, -> { distinct }, through: :picture_tags

  validates :name, presence: true
end
