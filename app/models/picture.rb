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

#yes i know this is a useless method, but I used it to figure out how to get and set pixels manually, don't judge me
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

  def color_percentages
    path = self.image.path
    image = ImageList.new(path)
    values = {}
    values[:red] = 0
    values[:blue] = 0
    values[:green] = 0
    new_pixels = image.get_pixels(0, 0, image.columns, image.rows)
    for pixel in new_pixels
      # if pixel.green > pixel.red  && pixel.green > pixel.blue
      #   values[:green] += pixel.green
      # elsif pixel.blue > pixel.red && pixel.blue > pixel.green
      #   values[:blue] += pixel.blue
      # elsif pixel.red > pixel.green && pixel.red > pixel.blue
      #   values[:red] += pixel.red
      # else
      #   #this means some of the pixel values are equal, do nothing
      # end
      values[:green] += pixel.green
      values[:blue] += pixel.blue
      values[:red] += pixel.red
    end
    total_count = values[:red] + values[:blue] + values[:green]
    answer = {
      :red_percentage => values[:red].to_f/total_count,
      :green_percentage => values[:green].to_f/total_count,
      :blue_percentage => values[:blue].to_f/total_count
    }

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





end
