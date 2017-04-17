class PictureCategory < ApplicationRecord
  belongs_to :picture
  belongs_to :category
end
