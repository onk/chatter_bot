class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.string :chatter_id, null: false
      t.integer :user_id
      t.string :url

      t.timestamps
    end
    add_index :likes, :chatter_id, unique: true
  end
end



