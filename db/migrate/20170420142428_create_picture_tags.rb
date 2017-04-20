class CreatePictureTags < ActiveRecord::Migration[5.0]
  def change
    create_table :picture_tags do |t|
      t.integer :picture_id
      t.integer :tag_ig
    end
  end
end
