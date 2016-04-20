module Weasel
  def audit_with_weasel(*args)
    around_filter :audit, only: args
  end

  module Auditable
    def audit
      yield

      Weasel::Event.create! do |object|
        object.actor = current_user

        rails_action = "#{params[:controller]}:#{params[:action]}"
        rails_parameters = params.except(:controller, :action)

        object.action_data = {
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

    def geo_service
      @@geoip ||= GeoIP.new(File.join(Rails.root, 'tmp/GeoIP.dat'))
    end
  end
end
