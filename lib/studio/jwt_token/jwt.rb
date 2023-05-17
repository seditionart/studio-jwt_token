# frozen_string_literal: true

require "jwt"
require "securerandom"

module Studio
  # Sedition Website App authentication token.
  module JwtToken
    # JWT wrapper using configuration defaults
    class Jwt
      attr_reader :secret, :algorithm, :kid

      # @param algorithm [String] (JwtToken.configuration.jwt_algorithm)
      # @param secret [String] (JwtToken.configuration.secret)
      # * automtaically set to algorithm depending default if not provided
      # @param kid [String] (JwtToken.configuration.kid)
      def initialize(secret: nil, algorithm: nil, kid: nil)
        @algorithm = algorithm || JwtToken.configuration.jwt_algorithm
        @kid = kid || JwtToken.configuration.kid

        @secret = secret || default_secret
      end

      # @param payload [Hash]
      # @return [String]
      def encode(payload)
        ::JWT.encode payload,
                     @secret,
                     @algorithm,
                     { type: "JWT", kid: @kid }
      end

      # @param jwt_token [String]
      # @return [Array]
      def decode(jwt_token)
        ::JWT.decode jwt_token,
                     @secret,
                     true,
                     { algorithm: @algorithm }
      end

      private

      # @return [String] depending on the algorithm
      def default_secret
        case @algorithm
        when "RS256"
          JwtToken.configuration.private_key
        when "HS256"
          JwtToken.configuration.secret
        else
          raise "Invalid JWT algorithm #{@algorithm}"
        end
      end
    end
  end
end
