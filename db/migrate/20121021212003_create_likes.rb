class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.string :chatter_id
      t.integer :user_id
      t.string :url

      t.timestamps
    end
  end
end



