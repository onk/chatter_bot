module ChatterBot
  class Comment < ActiveRecord::Base
    include Model
    chatter_nested_attributes ["user"]
    chatter_text_attributes ["body"]
  end
end

