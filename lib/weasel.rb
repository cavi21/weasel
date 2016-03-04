require 'active_record'

require 'weasel/models/event'
require 'weasel/version'

module Weasel
  def self.root
    File.expand_path('../..', __FILE__)
  end
end
