module Weasel
  def audit_with_weasel(*args)
    around_filter :audit, only: args
  end

  module Auditable
    def audit
      yield

      Weasel::EventsWorker.perform_async(current_user.id, thin_request)
    end

    private

    def thin_request
      parameters = request.params

      rails_action = "#{parameters[:controller]}:#{parameters[:action]}"
      rails_parameters = parameters.except(:controller, :action)

      {
        action: rails_action,
        params: rails_parameters,
        remote_ip: request.remote_ip,
        geo_ip_information: geo_ip_information,
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

    def geo_ip_information
      geo_service.country(request.remote_ip).to_h
    end

    def geo_service
      @@geoip ||= GeoIP.new(File.join(Rails.root, 'tmp/GeoIP.dat'))
    end
  end
end
