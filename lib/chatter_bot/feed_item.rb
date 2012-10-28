module ChatterBot
  class FeedItem < ActiveRecord::Base
    include Model
    belongs_to :parent, polymorphic: true
    belongs_to :actor, class_name: "ChatterBot::User", foreign_key: :actor_id

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
          if v && v["id"]
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

    def notify
      puts "------------------------------------------------------------------------"
      if parent.is_a?(Group)
        puts parent.name + ":"
      end
      puts "#{self.actor.name}: #{self.text}"
    end
  end
end

