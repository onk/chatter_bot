module ChatterBot
  module Model
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def by_chatter_id(chatter_id)
        where(chatter_id: chatter_id)
      end

      def find_by_chatter_id(chatter_id)
        self.by_chatter_id(chatter_id).first
      end

      def find_or_create_by_raw_hash(raw_hash)
        obj = self.find_by_chatter_id(raw_hash["id"])
        unless obj
          obj = self.new
          obj.set_values(raw_hash)
          obj.save!
        end
        obj
      end

      def chatter_nested_attributes(names)
        @chatter_nested_attribute_names = names
      end
      attr_reader :chatter_nested_attribute_names

      def chatter_text_attributes(names)
        @chatter_text_attribute_names = names
      end
      attr_reader :chatter_text_attribute_names
    end

    def set_values(raw_hash)
      raw_hash.each do |k, v|
        column_name = k.underscore
        if k == "id"
          self.chatter_id = v
        elsif k == "type"
          self.__send__("#{column_name}=", "ChatterBot::#{v}")
        elsif self.class.chatter_nested_attribute_names && self.class.chatter_nested_attribute_names.include?(column_name)
          obj = "ChatterBot::#{column_name.capitalize}".constantize.find_or_create_by_raw_hash(v)
          self.__send__("#{column_name}_id=", obj.id)
        elsif self.class.chatter_text_attribute_names && self.class.chatter_text_attribute_names.include?(column_name)
          self.__send__("text=", v["text"])
        elsif self.class.column_names.include?(column_name)
          self.__send__("#{column_name}=", v)
        else
          p ["#{self.class.name},#{column_name}", v]
        end
      end
    end
  end

  class Attachment < ActiveRecord::Base
    include Model
  end
  class Like < ActiveRecord::Base
    include Model
    chatter_nested_attributes ["user"]
  end
  class Comment < ActiveRecord::Base
    include Model
    chatter_nested_attributes ["user"]
    chatter_text_attributes ["body"]
  end
  class User < ActiveRecord::Base
    include Model
  end
  class Group < ActiveRecord::Base
    include Model
  end
  class CollaborationGroup < Group
  end
  class FeedItem < ActiveRecord::Base
    include Model
    def self.find_or_create_parent(raw_hash)
      if raw_hash["parent"]
        if raw_hash["parent"] == raw_hash["actor"]
          # 一般の POST は nil を返す
          return nil
        else
          if raw_hash["parent"]["type"] == "CollaborationGroup"
            # group
            Group.find_or_create_by_raw_hash(raw_hash["parent"])
          end
        end
      end
    end

    def self.create_by_raw_hash(raw_hash)
      hash = {}
      raw_hash.each {|k,v|
        case k
        when "id"
          hash["chatter_id"] = v
        when "actor"
          if v
            actor = User.find_or_create_by_raw_hash(v)
            hash["actor_id"] = actor.id
          end
        when "parent"
          parent = find_or_create_parent(raw_hash)
          if parent
            hash["parent_type"] = parent.class.name
            hash["parent_id"] = parent.id
          end
        when "attachment"
          if v
            attachment = Attachment.find_or_create_by_raw_hash(v)
            hash["attachment_id"] = attachment.id
          end
        when "body"
          hash["text"] = v["text"]
        when "likes"
          v["likes"].each do |like|
            Like.find_or_create_by_raw_hash(like)
          end
        when "comments"
          v["comments"].each do |comment|
            Comment.find_or_create_by_raw_hash(comment)
          end
        when "isLikedByCurrentUser", "currentUserLike"
          # nop
        else
          hash[k] = v
        end
      }
      FeedItem.create(hash)
    end
  end

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
      FeedItem.create_by_raw_hash(feed_item.raw_hash)
    end
    p "========================================================================="
    # puts feed_items.first.raw_hash["actor"].keys.inspect
    p "========================================================================="
  end
end

ChatterBot.setup
ChatterBot.main

