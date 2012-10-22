module ChatterBot
  class Group < ActiveRecord::Base
    include Model
  end

  class CollaborationGroup < Group
  end
end

