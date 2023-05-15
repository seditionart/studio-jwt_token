# frozen_string_literal: true

require "jwt"
require_relative "jwt_token/version"
require_relative "jwt_token/configuration"
require_relative "jwt_token/jwt"
require_relative "jwt_token/payload"

module Studio
  # Sedition Website App aujwtthentication token.
  module JwtToken
    class Error < StandardError; end
    class Invalid < Error; end
    class MatchError < Error; end

    extend Jwt

    class << self
      attr_accessor :configuration

      # Suggested to be used by apps which include this gem
      DEFAULT_HEADER_NAME = "Authorization"

      def configure(**kwargs)
        self.configuration ||= Configuration.new(**kwargs)
        yield configuration if block_given?
        configuration
      end

      def generate_jwt_token(payload = {}, **kwargs)
        jwt_encode(payload, **kwargs)
      end

      # The auth token
      def auth_token
        configuration.auth_token
      end

      # @return [Hash,nil]
      # @raise [Invalid]
      def jwt_token_payload(jwt_token)
        begin
          result = jwt_decode(jwt_token)
        rescue JWT::DecodeError => e
          raise(Studio::JwtToken::Invalid, "Unable to decode invalid token (#{e.message}).")
        end
        result.first
      end
    end
  end
end
