class CreatePictures < ActiveRecord::Migration[5.0]
  def change
    create_table :pictures do |t|
      t.column :image, :oid, null: false
      t.integer :user_id
    end
  end
end
