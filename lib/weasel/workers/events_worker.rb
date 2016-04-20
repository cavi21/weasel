class EventsWorker
  include Sidekiq::Worker

  def perform(user_id, request_hash)
    return if user_id.nil? || request_hash.empty?

    Weasel::Event.create do |object|
      object.actor = User.find(user_id)
      object.action_data = request_hash
    end
  end
end
