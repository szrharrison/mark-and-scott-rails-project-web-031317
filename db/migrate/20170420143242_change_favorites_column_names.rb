class ChangeFavoritesColumnNames < ActiveRecord::Migration[5.0]
  def up
    rename_column :favorites, :user_id, :favorited_by
    rename_column :favorites, :picture_id, :favorite_picture
  end

  def down
    rename_column :favorites, :favorited_by, :user_id
    rename_column :favorites, :favorite_picture, :picture_id
  end
end
