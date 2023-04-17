# frozen_string_literal: true

require "jwt"

module Studio
  # Sedition Website App authentication token.
  module JwtToken
    module Jwt
      # @return [String]
      def jwt_encode(**kwargs)
        JWT.encode kwargs,
                   JwtToken.configuration.jwt_hmac_secret,
                   JwtToken.configuration.jwt_algorithm
      end

      # @return [Array]
      def jwt_decode(jwt_token)
        JWT.decode jwt_token,
                   JwtToken.configuration.jwt_hmac_secret,
                   true,
                   { algorithm: JwtToken.configuration.jwt_algorithm }
      end
    end
  end
end
