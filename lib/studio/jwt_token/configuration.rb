# frozen_string_literal: true

module Studio
  module JwtToken
    # JwtToken Configuration
    class Configuration
      attr_accessor :public_key, :private_key, :comment, :algorithm, :secret, :kid, :domain, :audience

      # rubocop:disable Metrics
      # @param public_key [String,nil] path to a pem file or string containing an RSA key
      # @param private_key [String,nil] path to a pem file or string containing an RSA key
      # @param algorithm [String,nil]
      # @param kid [String,nil]
      # @param secret [String,nil]
      # @param comment [String,nil]
      def initialize(algorithm: "HS256",
                     public_key: nil,
                     private_key: nil,
                     comment: nil,
                     kid: nil,
                     secret: nil,
                     domain: nil,
                     audience: nil)
        @algorithm = ENV.fetch("STUDIO_JWT_ALGORITHM", algorithm)

        @kid = ENV.fetch("STUDIO_JWT_SECRET_KID", kid) if @algorithm == "RS256"

        @domain = ENV.fetch("STUDIO_JWT_AUTH0_DOMAIN", domain)
        @audience = ENV.fetch("STUDIO_JWT_AUTH0_AUDIENCE", audience)

        @secret = ENV.fetch("STUDIO_JWT_SECRET", secret)
        @secret = (File.exist?(@secret) ? File.read(@secret) : @secret) if @secret

        @private_key = could_be_file_or_rsa_key(private_key || ENV.fetch("STUDIO_JWT_PRIVATE", nil))
        @public_key = could_be_file_or_rsa_key(public_key || ENV.fetch("STUDIO_JWT_PUBLIC", nil))

        @comment = comment
      end
      # rubocop:enable Metrics

      # @param str [String] path to a pem file or string containing an RSA key
      # @return [Hash]
      def could_be_file_or_rsa_key(str)
        return unless str.is_a?(String)

        File.exist?(str) ? File.read(str) : str
        # OpenSSL::PKey::RSA.new(rsa_key)
      end
    end
  end
end
