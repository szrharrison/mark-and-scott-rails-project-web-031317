require 'RMagick'
require 'face_detect'
require 'face_detect/adapter/google'
require 'rest_client'
require 'base64'
require 'json'
GOOGLE_CREDENTIALS_JSON= "/Users/admin/flatiron/labs/rails/mark-and-scott-rails-project-web-031317/keys/pixr-23da4be727f5.json"
include Magick

class Picture < ApplicationRecord
  has_attached_file :image, default_url: "/images/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  has_many :picture_categories
  has_many :categories, -> { distinct }, through: :picture_categories
  has_many :picture_tags
  has_many :tags, -> { distinct }, through: :picture_tags
  belongs_to :user
  has_many :favorites, foreign_key: "favorite_picture_id"
  has_many :favorited_by, -> { distinct }, through: :favorites

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

  def make_bigger

    path = self.image.path
    image = ImageList.new(path)
    image = image.magnify
    image.write(path.gsub(/\/original\/(.+\.)(...|....)/, '/original/bigger-\1\2'))
  end

  def make_smaller

    path = self.image.path
    image = ImageList.new(path)
    image = image.minify
    image.write(path.gsub(/\/original\/(.+\.)(...|....)/, '/original/smaller-\1\2'))
  end

  def thumbnail
    path = self.image.path
    image = ImageList.new(path)
    image = image.thumbnail
    image.write(path.gsub(/\/original\/(.+\.)(...|....)/, '/original/thumbnail-\1\2'))
  end

  def flip_vertical
    path = self.image.path
    image = ImageList.new(path)
    image = image.flip
    image.write(path.gsub(/\/original\/(.+\.)(...|....)/, '/original/vertical-flip-\1\2'))
  end

  def flip_horizontal
    path = self.image.path
    image = ImageList.new(path)
    image = image.flop
    image.write(path.gsub(/\/original\/(.+\.)(...|....)/, '/original/vertical-flip-\1\2'))
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

  def tagorize
    #implicit self, self.tags and tags are the same thing here
    if green?
      tags << Tag.find_or_create_by(name: "Green")
    end
    if red?
      tags << Tag.find_or_create_by(name: "Red")
    end
    if blue?
      tags << Tag.find_or_create_by(name: "Blue")
    end
    if gray?
      tags << Tag.find_or_create_by(name: "Gray")
    end
    if face?
      tags << Tag.find_or_create_by(name: "Face")
    end
  end

  def tagorize_improved
    #temporarily hosting the image on another site
    image_url = Cloudinary::Uploader.upload(image.path)["url"]
    api_key = 'acc_486bae7d99a8cbd'
    api_secret = 'ceaecba1e6d0db768df9671338a18a34'

    auth = 'Basic ' + Base64.strict_encode64( "#{api_key}:#{api_secret}" ).chomp
    response = RestClient.get "https://api.imagga.com/v1/tagging?url=#{image_url}", { :Authorization => auth }
    data = JSON.parse(response)
    data["results"][0]["tags"][0..5].each do |element|
      tags << Tag.find_or_create_by(name: element["tag"])
    end

  end


  def face?
    if face_detect
      #if this returns an object, it means a face was detected
      true
    else
      false
    end
  end

  def face_detect
    input = File.new(image.path)
    detector = FaceDetect.new(
      file: input,
      adapter: FaceDetect::Adapter::Google
    )
    results = detector.run
    #results
    face = results.first
    face
  end

end
