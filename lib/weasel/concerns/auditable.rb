module Weasel
  def audit_with_weasel(*args)
    around_action :audit, only: args
  end

  module Auditable
    def audit
      begin
        yield
      ensure
        return unless actor.present?

        Weasel::EventsWorker.perform_async(actor.class.name, actor.id, request_data)
      end
    end

    private

    def actor
      return current_user if defined?(current_user)
      return current_admin if defined?(current_admin)
    end

    def request_data
      parameters = if request.respond_to?(:filtered_parameters)
        request.filtered_parameters
      else
        request.params
      end

      rails_action = "#{parameters[:controller]}:#{parameters[:action]}"
      rails_parameters = parameters.except(:controller, :action)

      {
        action: rails_action,
        params: rails_parameters,
        remote_ip: request.remote_ip,
        geo_ip_information: geo_ip_information,
        user_agent: request.user_agent
      }
    end

    def geo_ip_information
      info = geo_service.lookup(request.remote_ip)

      info.to_hash
    end

    def geo_service
      @@maxmind ||= ::MaxMindDB.new( Rails.root.join('tmp', 'GeoLite2-City.mmdb'))
    end
  end
end
