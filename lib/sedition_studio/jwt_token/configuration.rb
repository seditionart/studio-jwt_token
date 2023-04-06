# frozen_string_literal: true

module SeditionStudio
  module JwtToken
    # JwtToken Configuration
    class Configuration
      attr_reader :auth_token, :jwt_hmac_secret, :jwt_algorithm

      def initialize(jwt_hmac_secret: nil, jwt_algorithm: nil, auth_token: nil)
        @jwt_hmac_secret = ENV.fetch("STUDIO_JWT_HMAC_SECRET", nil) || jwt_hmac_secret
        @jwt_algorithm = ENV.fetch("STUDIO_JWT_ALGORITHM", nil) || jwt_algorithm
        @auth_token = ENV.fetch("STUDIO_AUTH_TOKEN", nil) || auth_token
      end
    end
  end
end
