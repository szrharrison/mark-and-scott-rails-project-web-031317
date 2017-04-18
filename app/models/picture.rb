class Picture < ApplicationRecord
  has_attached_file :image, default_url: "/images/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  has_many :picture_categories
  has_many :categories, through: :picture_categories
  belongs_to :user

  validates :user_id, presence: true
  validates :image, presence: true

  def non_category
    Category.all - categories
  end

  def category_list=(string)
    categories_array = string.split(",")
    categories_array = categories_array.map do |category|
      Category.find_or_create_by( name: category.strip )
    end
    self.categories = categories_array
  end
end
