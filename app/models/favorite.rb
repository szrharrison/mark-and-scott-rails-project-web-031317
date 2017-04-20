class Favorite < ApplicationRecord
  belongs_to :favorited_by, class_name: "User"
  belongs_to :favorite_picture, class_name: "Picture"
end
