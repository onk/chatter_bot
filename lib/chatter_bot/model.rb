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
end

