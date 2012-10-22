class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|
      t.string :chatter_id, null: false
      t.integer :actor_id
      t.integer :attachment_id
      t.text :text
      t.string :parent_type
      t.integer :parent_id

      t.string :clientInfo
      t.string :comments
      t.string :createdDate
      t.string :event
      t.string :modifiedDate
      t.string :photoUrl
      t.string :type
      t.string :url

      t.timestamps
    end
    add_index :feed_items, :chatter_id, unique: true
  end
end

