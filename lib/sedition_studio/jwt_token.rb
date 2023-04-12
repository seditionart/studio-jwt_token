# frozen_string_literal: true

require "jwt"
require_relative "jwt_token/version"
require_relative "jwt_token/configuration"
require_relative "jwt_token/jwt"

module SeditionStudio
  # Sedition Website App aujwtthentication token.
  module JwtToken
    class Error < StandardError; end
    class Invalid < Error; end
    class MatchError < Error; end

    extend Jwt

    class << self
      attr_accessor :configuration

      AUTH_TOKEN_KEY = "auth_token"
      # Suggested to be used by apps which include this gem
      DEFAULT_HEADER_NAME = "App-Authorization"

      def configure(**kwargs)
        self.configuration ||= Configuration.new(**kwargs)
        yield configuration if block_given?
        configuration
      end

      def generate_jwt_token(**kwargs)
        jwt_encode(auth_token: configuration.auth_token, **kwargs)
      end

      # The auth token
      def auth_token
        configuration.auth_token
      end

      # Does the token passed on match the env value
      #
      # @param jwt_token [String]
      # @param key [String] (AUTH_TOKEN_KEY) The key to look for in the payload
      # @return [Booelan]
      def auth_token_match?(jwt_token, key: AUTH_TOKEN_KEY)
        jwt_token_payload(jwt_token)[key] == configuration.auth_token
      end

      # @param (see #auth_token_match?)
      # @return [Boolean]
      # @raise [MatchError] if the token does not match
      def auth_token_match!(jwt_token, key: AUTH_TOKEN_KEY)
        auth_token_match?(jwt_token, key: key) ? true : raise(MatchError, "Token are different.")
      end

      # @return [Hash,nil]
      # @raise [Invalid]
      def jwt_token_payload(jwt_token)
        begin
          result = jwt_decode(jwt_token)
        rescue JWT::DecodeError => e
          raise(SeditionStudio::JwtToken::Invalid, "Unable to decode invalid token (#{e.message}).")
        end
        result.first
      end
    end
  end
end
