class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :chatter_id
      t.string :mime_type
      t.string :description
      t.string :title
      t.string :version_id
      t.integer :file_size
      t.string :file_type
      t.string :download_url
      t.boolean :has_image_preview
      t.boolean :has_pdf_preview

      t.timestamps
    end
    add_index :attachments, :chatter_id, unique: true
  end
end

