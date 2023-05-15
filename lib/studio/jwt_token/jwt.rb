# frozen_string_literal: true

require "jwt"

module Studio
  # Sedition Website App authentication token.
  module JwtToken
    # JWT token encoding and decoding methods.
    module Jwt
      # @param payload [Hash]
      # @param jwt_token [String]
      # @param secret [String]
      # @param algorithm [String]
      # @return [String]
      def jwt_encode(payload,
                     secret: JwtToken.jwt_secret,
                     algorithm: JwtToken.jwt_algorithm)
        puts "payload: #{payload} secret: #{secret} algorithm: #{algorithm}"
        JWT.encode payload,
                   secret,
                   algorithm,
                   { type: "JWT", kid: SecureRandom.hex }
      end

      # @param jwt_token [String]
      # @param secret [String]
      # @param algorithm [String]
      # @return [Array]
      def decode(jwt_token,
                 secret: JwtToken.jwt_secret,
                 algorithm: JwtToken.jwt_algorithm)
        JWT.decode jwt_token,
                   secret,
                   true,
                   { algorithm: algorithm }
      end
    end
  end
end
