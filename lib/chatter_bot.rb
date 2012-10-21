module ChatterBot
  def self.main
    config = {
      client_id:     Pit.get("chatter_bot")["client_id"],
      client_secret: Pit.get("chatter_bot")["client_secret"],
      version:       "23.0"
    }
    client = Databasedotcom::Client.new(config)

    h = {
      token:         Pit.get("chatter_bot")["access_token"],
      instance_url:  "https://ap.salesforce.com"
    }
    client.authenticate(h)

    feed_items = Databasedotcom::Chatter::CompanyFeed.find(client)
    p "========================================================================="
    p feed_items.inspect
    p "========================================================================="
  end
end

ChatterBot.main

