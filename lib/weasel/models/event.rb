require 'action_pack'

module Weasel
  class Event < ActiveRecord::Base
    self.table_name = 'weasel_events'

    serialize :action_data

    belongs_to :actor, polymorphic: true

    def self.log(user_id, request)
      Weasel::Event.create do |object|
        object.actor = User.find(user_id)
        object.action_data = build_action_data(request)
      end
    end

    private

    def build_action_data(request)
      request = ActionDispatch::Request.new(request)
      parameters = request.params

      rails_action = "#{parameters[:controller]}:#{parameters[:action]}"
      rails_parameters = parameters.except(:controller, :action)

      hash = {
        action: rails_action,
        params: rails_parameters,
        remote_ip: request.remote_ip,
        country: geo_service.country(request.remote_ip).to_h,
        user_agent: request.user_agent,
        response: {
          status: response.status
        }.tap do |hash|
          hash[:body] = response.body if response.body
        end
      }.tap do |hash|
        hash[:flash] = request.flash if request.flash
      end
    end
  end
end
