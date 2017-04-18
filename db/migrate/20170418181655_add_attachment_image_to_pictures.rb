class AddAttachmentImageToPictures < ActiveRecord::Migration
  def self.up
    change_table :pictures do |t|
      t.attachment :image
      t.remove :image_url
    end
  end

  def self.down
    remove_attachment :pictures, :image
    add_column :pictures, :image_url, :string
  end
end
