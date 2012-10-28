class AddRawHashToFeedItems < ActiveRecord::Migration
  def change
    add_column :feed_items, :raw_hash, :text, after: :url
  end
end

