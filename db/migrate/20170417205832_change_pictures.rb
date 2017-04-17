class ChangePictures < ActiveRecord::Migration[5.0]
  def up
    change_table :pictures do |t|
      t.remove :image
      t.string :image_url
    end
  end

  def down
    change_table :pictures do |t|
      t.remove :image_url
      t.column :image, :oid, null: false
    end
  end

end
