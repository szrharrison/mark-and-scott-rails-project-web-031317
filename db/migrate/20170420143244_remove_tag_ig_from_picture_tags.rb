class RemoveTagIgFromPictureTags < ActiveRecord::Migration[5.0]
  def change
    remove_column :picture_tags, :tag_ig, :integer
  end
end
