require 'RMagick'
include Magick

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

  #modifier methods
  def greyscale
    #grabs path of image on our server
    path = self.image.path
    #create a new "Image List" object from the image at the path
    image = ImageList.new(path)
    #uses the quantize method to set the number of colors used in the image to 2
    image = image.quantize(nc=2)
    #this saves the file in the location it was before
    image.write(path.gsub(/\/original\/(.+\.)(...|....)/, '/original/grey-scale-\1\2'))
    #use this for testing, need to have X11 runnning for it to work
    #image.display
  end

  def edge
    #grabs path of image on our server
    path = self.image.path
    #create a new "Image List" object from the image at the path
    image = ImageList.new(path)
    #uses the quantize method to set the number of colors used in the image to 2
    image = image.edge
    #this saves the file in the location it was before
    image.write(path.gsub(/\/original\/(.+\.)(...|....)/, '/original/edge-detected-\1\2'))
    #use this for testing, need to have X11 runnning for it to work
    #image.display
  end
  #image evaluators
  def monochrome?
    path = self.image.path
    #create a new "Image List" object from the image at the path
    image = ImageList.new(path)
    #uses the quantize method to set the number of colors used in the image to 2
    image.monochrome?
    #this will return true if the image is monochrome, then we can add that as a category
  end

  def gray?
    path = self.image.path
    #create a new "Image List" object from the image at the path
    image = ImageList.new(path)
    #uses the quantize method to set the number of colors used in the image to 2
    image.gray?
    #this will return true if the image is monochrome, then we can add that as a category

  end
end
