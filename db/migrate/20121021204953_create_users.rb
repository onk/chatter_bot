class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :chatter_id, null: false

      t.string :company_name
      t.string :first_name
      t.boolean :is_chatter_guest
      t.string :last_name
      t.string :name
      t.string :photo
      t.string :title
      t.string :type
      t.string :url

      t.timestamps
    end
    add_index :users, :chatter_id, unique: true
  end
end


