# frozen_string_literal: true

module Studio
  module JwtToken
    # JwtToken Configuration
    class Configuration
      attr_accessor :public_key, :private_key, :comment, :jwt_algorithm, :secret, :kid, :domain

      # rubocop:disable Metrics
      # @param public_key [String,nil] path to a pem file or string containing an RSA key
      # @param private_key [String,nil] path to a pem file or string containing an RSA key
      # @param jwt_algorithm [String,nil]
      # @param kid [String,nil]
      # @param secret [String,nil]
      # @param comment [String,nil]
      def initialize(public_key: nil,
                     private_key: nil,
                     jwt_algorithm: nil,
                     comment: nil,
                     kid: nil,
                     secret: nil,
                     domain: nil,
                     audience: nil)
        @jwt_algorithm = jwt_algorithm || ENV.fetch("STUDIO_JWT_ALGORITHM", "RS256")

        @kid = kid || ENV.fetch("STUDIO_JWT_SECRET_KID", SecureRandom.hex)

        @domain = domain || ENV.fetch("STUDIO_JWT_AUTH0_DOMAIN", nil)
        @audience = audience || ENV.fetch("STUDIO_JWT_AUTH0_AUDIENCE", nil)

        @secret = secret || ENV.fetch("STUDIO_JWT_SECRET", nil)
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

        rsa_key = File.exist?(str) ? File.read(str) : str
        OpenSSL::PKey::RSA.new(rsa_key)
      end
    end
  end
end
