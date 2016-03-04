require 'active_record'

require 'weasel/models/event'
require 'weasel/version'

module Weasel
  def self.root
    File.expand_path('../..', __FILE__)
  end

  class Configuration
    attr_accessor :db_configuration
  end

  def self.config
    @@config ||= Configuration.new
  end

  def self.configure
    yield config

    ActiveRecord::Base.establish_connection(config.db_configuration)
  end
end
