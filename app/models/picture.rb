require 'RMagick'
include Magick

class Picture < ApplicationRecord
  has_attached_file :image, default_url: "/images/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  has_many :picture_categories
  has_many :categories, through: :picture_categories
  has_many :picture_tags
  has_many :tags, through: :picture_tags
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


  def grey_scale_improved
    path = self.image.path
    image = ImageList.new(path)
    new_pixels = image.get_pixels(0, 0, image.columns, image.rows)
    for pixel in new_pixels
      average = (pixel.red + pixel.green + pixel.blue) / 3
      pixel.red = average

      pixel.green = average
      pixel.blue = average
    end
    image.store_pixels(0,0, image.columns,image.rows, new_pixels)
    image.display
    #image.import_pixels(0,0,image.columns,image.rows,new_pixels, "RGB").display
  end


  #image evaluators
  def red?
    if color_percentages[:red_percentage] > 0.4
      true
    else
      false
    end
  end

  def blue?
    if color_percentages[:blue_percentage] > 0.4
      true
    else
      false
    end
  end

  def green?
    if color_percentages[:green_percentage] > 0.4
      true
    else
      false
    end
  end


  def color_percentages
    path = self.image.path
    image = ImageList.new(path)
    values = {}
    values[:red] = 0
    values[:blue] = 0
    values[:green] = 0
    new_pixels = image.get_pixels(0, 0, image.columns, image.rows)
    for pixel in new_pixels
      values[:green] += pixel.green
      values[:blue] += pixel.blue
      values[:red] += pixel.red
    end
    total_count = values[:red] + values[:blue] + values[:green]

    #return
    {
      :red_percentage => values[:red].to_f/total_count,
      :green_percentage => values[:green].to_f/total_count,
      :blue_percentage => values[:blue].to_f/total_count
    }

    #deprecated: old return for max percentage, now handling in separate method
    # values.max_by{|k,v| v}[0]

  end

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

  def categorize
    if green?
      categories << Category.find_or_create_by(name: "Green")
    end
    if red?
      categories << Category.find_or_create_by(name: "Red")
    end
    if blue?
      categories << Category.find_or_create_by(name: "Blue")
    end
    if gray?
      categories << Category.find_or_create_by(name: "Gray")
    end
  end





end
