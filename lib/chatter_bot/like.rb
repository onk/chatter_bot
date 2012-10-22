module ChatterBot
  class Like < ActiveRecord::Base
    include Model
    chatter_nested_attributes ["user"]
  end
end

