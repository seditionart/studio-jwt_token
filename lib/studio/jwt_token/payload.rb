# frozen_string_literal: true

require "jwt"

module Studio
  # Sedition Website App authentication token.
  module JwtToken
    # Payload for Studio's the JWT token
    class Payload
      attr_reader :audience, :azp, :domain, :sub, :iat, :expiry, :scopes, :scheme

      # rubocop:disable Metrics/ParameterLists
      # @param domain [String] (JwtToken.configuration.domain)
      # @param audience [String] (JwtToken.configuration.audience)
      # @param sub [String] ("")
      # @param azp [String] (SecureRandom.hex)
      # @param scheme [String]
      # @param scopes [Array] (["manage:all"])
      # @param iat [Integer] (Time.now.to_i)
      # @param expiry [Integer] (Time.now.to_i + 86_400)
      def initialize(domain:,
                     audience:,
                     sub: "",
                     azp: SecureRandom.hex,
                     scopes: ["manage:all"],
                     iat: Time.now.to_i,
                     scheme: "https",
                     expiry: (Time.now.to_i + 86_400))
        @audience = audience || JwtToken.configuration.audience
        @domain = domain || JwtToken.configuration.domain
        @azp = azp
        @expiry = expiry
        @scheme = scheme
        @iat = iat
        @scopes = scopes
        @sub = sub
      end
      # rubocop:enable Metrics/ParameterLists

      # @return [Hash]
      # @example { iss: "https://seditionart-dev.eu.auth0.com/",
      #            sub: "auth0|0",
      #            aud: ["dev/graphql", "https://seditionart-dev.eu.auth0.com/userinfo"],
      #            iat: 1577836800,
      #            exp: 1577923200,
      #            azp: "1234567890",
      #            scope: "openid profile manage:all" }
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

      # @params (see JwtToken::Jwt#initialize)
      # @return [String]
      def token(**kwargs)
        JwtToken::Jwt.new(**kwargs).encode(to_h)
      end
    end
  end
end
