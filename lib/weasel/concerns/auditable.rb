module Weasel
  def audit_with_weasel(*args)
    around_filter :audit, only: args
  end

  module Auditable
    def audit
      yield

      Weasel::Event.delay.log(current_user.as_json, request.as_json)
    end

    def geo_service
      @@geoip ||= GeoIP.new(File.join(Rails.root, 'tmp/GeoIP.dat'))
    end
  end
end
