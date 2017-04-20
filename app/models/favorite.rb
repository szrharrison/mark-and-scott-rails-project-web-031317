class Favorite < ApplicationRecord
  belongs_to :favorited_by, class_name: "User", foreign_key: "favorited_by_id"
  belongs_to :favorite_picture, class_name: "Picture", foreign_key: "favorite_picture_id"
end
