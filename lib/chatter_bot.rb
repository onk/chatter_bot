require "chatter_bot/version"

require "active_record"
require "pit"
require "databasedotcom"

require "chatter_bot/model"
require "chatter_bot/attachment"
require "chatter_bot/like"
require "chatter_bot/comment"
require "chatter_bot/user"
require "chatter_bot/group"
require "chatter_bot/feed_item"
module ChatterBot
  def self.setup
    config = {
      client_id:     Pit.get("chatter_bot")["client_id"],
      client_secret: Pit.get("chatter_bot")["client_secret"],
      version:       "23.0"
    }
    @client = Databasedotcom::Client.new(config)
    h = {
      token:         Pit.get("chatter_bot")["access_token"],
      instance_url:  "https://ap.salesforce.com"
    }
    @client.authenticate(h)

    db_config = YAML.load_file("config/database.yml")
    ActiveRecord::Base.establish_connection(db_config)
  end

  def self.main
    feed_items = Databasedotcom::Chatter::CompanyFeed.find(@client)
    feed_items.each do |feed_item|
      db_feed_item = FeedItem.find_by_chatter_id(feed_item.id)
      unless db_feed_item
        p "#{feed_item.raw_hash["actor"]["name"]}: #{feed_item.raw_hash["body"]["text"]}"
        FeedItem.create_by_raw_hash(feed_item.raw_hash)
      end
    end
  end
end

