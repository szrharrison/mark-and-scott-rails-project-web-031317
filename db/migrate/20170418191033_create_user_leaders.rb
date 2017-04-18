class CreateUserLeaders < ActiveRecord::Migration[5.0]
  def change
    create_table :user_leaders do |t|
      t.integer :user_id
      t.integer :leader_id
    end
  end
end
