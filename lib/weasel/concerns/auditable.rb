module Weasel
  def audit_with_weasel(*args)
    around_filter :thing, only: args
  end

  module Auditable
    def thing
      yield

      Weasel::Event.create! do |object|
        object.actor = current_user

        rails_action = "#{params[:controller]}:#{params[:action]}"
        rails_parameters = params.except(:controller, :action)

        object.action_data = {
          action: rails_action,
          params: rails_parameters,
          flash: request.flash,
          remote_ip: request.remote_ip,
          geo_ip: geoip.city(request.remote_ip).to_h,
          user_agent: request.user_agent,
          response: {
            status: response.status
          }.tap do |hash|
            hash[:body] = response.body if response.body
          end
        }
      end

      def geoip
        @@geoip ||= GeoIP.new(File.join(Rails.root, 'tmp/GeoIP.dat'))
      end
    end
  end
end
