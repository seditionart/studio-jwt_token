# frozen_string_literal: true

module Studio
  module JwtToken
    # JwtToken Configuration
    class Configuration
      attr_accessor :auth_token, :jwt_hmac_secret, :jwt_algorithm

      def initialize(jwt_hmac_secret: nil, jwt_algorithm: nil, auth_token: nil)
        @jwt_hmac_secret = jwt_hmac_secret || ENV.fetch("STUDIO_JWT_HMAC_SECRET", nil)
        @jwt_algorithm = jwt_algorithm || ENV.fetch("STUDIO_JWT_ALGORITHM", nil)
        @auth_token = auth_token || ENV.fetch("STUDIO_AUTH_TOKEN", nil)
      end
    end
  end
end
