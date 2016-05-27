module Weasel
  class EventsWorker
    include Sidekiq::Worker

    def perform(actor_class, actor_id, request_hash)
      return if actor_class.nil? || actor_id.nil? || request_hash.empty?

      Weasel::Event.create do |object|
        object.actor = actor_class.constantize.find(actor_id)
        object.action_data = request_hash
      end
    end
  end
end
