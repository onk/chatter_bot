class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :chatter_id, null: false
      t.string :name
      t.string :description
      t.string :visibility
      t.boolean :can_have_chatter_guests
      t.string :photo
      t.string :url
      t.string :type

      t.timestamps
    end
    add_index :groups, :chatter_id, unique: true
  end
end

