module Weasel
  class Event < ActiveRecord::Base
    self.table_name = 'weasel_events'

    serialize :action_data

    belongs_to :actor, polymorphic: true
  end
end
