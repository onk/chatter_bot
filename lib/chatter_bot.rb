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
    p "========================================================================="
    p feed_items.inspect
    p "========================================================================="
  end
end

ChatterBot.setup
ChatterBot.main

