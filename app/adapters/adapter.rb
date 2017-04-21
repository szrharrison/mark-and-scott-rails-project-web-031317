module Adapter
  require 'RMagick'
  require 'face_detect'
  require 'face_detect/adapter/google'
  require 'rest_client'
  require 'base64'
  require 'json'
  GOOGLE_CREDENTIALS_JSON= "/Users/admin/flatiron/labs/rails/mark-and-scott-rails-project-web-031317/keys/pixr-23da4be727f5.json"
  include Magick
  #code
  class CloudinaryAdapter

    def self.generate_url_for(image)
      Cloudinary::Uploader.upload(image.path)["url"]
    end
  end

  class RestClientAdapter

    def self.generate_authorization_string
      api_key = 'acc_486bae7d99a8cbd'
      api_secret = 'ceaecba1e6d0db768df9671338a18a34'
      'Basic ' + Base64.strict_encode64( "#{api_key}:#{api_secret}" ).chomp
    end

    def self.generate_response(image_url)
      RestClient.get "https://api.imagga.com/v1/tagging?url=#{image_url}", { :Authorization => generate_authorization_string }
    end

    def self.generate_tags(response)
      data = JSON.parse(response)
      data["results"][0]["tags"]
    end


  end
end
