class RenameFavoritesColumns < ActiveRecord::Migration[5.0]
  def up
    rename_column :favorites, :favorited_by, :favorited_by_id
    rename_column :favorites, :favorite_picture, :favorite_picture_id
  end

  def down
    rename_column :favorites, :favorited_by_id, :favorited_by
    rename_column :favorites, :favorite_picture_id, :favorite_picture
  end
end
