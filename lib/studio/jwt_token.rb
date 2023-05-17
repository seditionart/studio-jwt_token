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

    class << self
      attr_accessor :configuration

      # Suggested to be used by apps which include this gem
      DEFAULT_HEADER_NAME = "Authorization"

      def configure(**kwargs)
        self.configuration ||= Configuration.new(**kwargs)
        yield configuration if block_given?
        configuration
      end

      # @param payload [Hash]
      # @param kwargs (see JwtToken::Jwt#initialize)
      # @return [String]
      def encode(payload = {}, **kwargs)
        JwtToken::Jwt.new(**kwargs).encode(payload)
      end

      def decode(token, **kwargs)
        JwtToken::Jwt.new(**kwargs).decode(token)
      end

      # @return [Hash,nil]
      # @raise [Invalid]
      def jwt_token_payload(jwt_token)
        begin
          result = decode(jwt_token)
        rescue JWT::DecodeError => e
          raise(Studio::JwtToken::Invalid, "Unable to decode invalid token (#{e.message}).")
        end
        result.first
      end
    end
  end
end
