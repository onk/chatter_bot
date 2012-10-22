class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :chatter_id, null: false
      t.string :parent
      t.string :user_id
      t.string :client_info
      t.string :url
      t.text :text
      t.string :created_date
      t.string :feed_item
      t.string :deletable

      t.timestamps
    end
    add_index :comments, :chatter_id, unique: true
  end
end

