# frozen_string_literal: true

require "jwt"

module Studio
  # Sedition Website App authentication token.
  module JwtToken
    # Payload for Studio's the JWT token
    class Payload
      attr_reader :audience, :azp, :domain, :sub, :iat, :expiry, :scopes, :scheme

      # rubocop:disable Metrics/ParameterLists
      # @param domain [String]
      # @param audience [String]
      # @param sub [String]
      # @param azp [String]
      # @param scheme [String]
      # @param scopes [Array]
      # @param iat [Integer]
      # @param expiry [Integer]
      def initialize(domain:,
                     audience:,
                     sub: "",
                     azp: SecureRandom.hex,
                     scheme: "https",
                     scopes: ["manage:all"],
                     iat: Time.now.to_i,
                     expiry: (Time.now.to_i + 86_400))
        @audience = audience
        @azp = azp
        @domain = domain
        @expiry = expiry
        @iat = iat
        @scheme = scheme
        @scopes = scopes
        @sub = sub
      end
      # rubocop:enable Metrics/ParameterLists

      # @return [Hash]
      def to_h
        {
          iss: "#{scheme}://#{domain}/",
          sub: sub,
          aud: [audience, "#{scheme}://#{domain}/userinfo"],
          iat: iat,
          exp: expiry,
          azp: azp,
          scope: "openid profile #{scopes.join}"
        }
      end
    end
  end
end
