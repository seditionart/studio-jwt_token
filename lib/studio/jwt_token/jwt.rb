# frozen_string_literal: true

require "jwt"
require "openssl"
require "securerandom"

module Studio
  # Sedition Website App authentication token.
  module JwtToken
    # JWT token encoding and decoding methods.
    module Jwt
      # @param payload [Hash]
      # @param jwt_token [String]
      # @param secret [String, OpenSSL::PKey::RSA]
      # @param algorithm [String]
      # @param kid [String]
      # @return [String]
      def jwt_encode(payload,
                     secret: JwtToken.jwt_secret,
                     algorithm: JwtToken.jwt_algorithm,
                     kid: SecureRandom.hex)

        JWT.encode payload,
                   secret,
                   algorithm,
                   { type: "JWT", kid: kid }.compact
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

      # def rsa_private
      #   OpenSSL::PKey::RSA.generate 2048
      # end
    end
  end
end
