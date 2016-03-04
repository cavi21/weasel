module Weasel
  def audit_with_weasel(*args)
    around_filter :thing, only: args
  end

  module Auditable
    def thing
      yield

      Weasel::Event.create! do |object|
        object.actor = current_user
        object.action_data = {
          flash: request.flash,
          params: request.params,
          remote_ip: request.remote_ip,
          response: {
            status: response.status
          }.tap do |hash|
            hash[:body] = response.body if response.body
          end
        }
      end
    end

  end
end
