class AddTagIdToPictureTags < ActiveRecord::Migration[5.0]
  def change
    add_column :picture_tags, :tag_id, :integer
  end
end
