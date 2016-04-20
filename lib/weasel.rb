require 'active_record'
require 'active_support/concern'

require 'weasel/concerns/auditable'
require 'weasel/models/event'
require 'weasel/workers/events_worker'
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

    # Connect to current AR connection.
    ActiveRecord::Base.establish_connection(config.db_configuration)

    # Extend ActionController with the `audit_with_weasel` method.
    ActionController::Base.extend(Weasel)
    ActionController::Base.send(:include, Weasel::Auditable)
  end
end
