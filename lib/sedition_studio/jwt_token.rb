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

    extend Jwt

    class << self
      attr_accessor :configuration

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
      # @return [Booelan]
      def auth_token_match?(jwt_token, key: "auth_token")
        jwt_token_payload(jwt_token)[key] == configuration.auth_token
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
