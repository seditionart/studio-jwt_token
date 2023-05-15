# frozen_string_literal: true

require "securerandom"

# rubocop:disable  Metrics/BlockLength
RSpec.describe Studio::JwtToken::Payload do
  # Using
  let(:domain) { "seditionart-dev.eu.auth0.com" }
  let(:sub) { "" }
  let(:audience) { "dev/graphql" }
  let(:azp) { SecureRandom.hex }
  let(:scheme) { "https" }
  let(:scopes) { %w[manage:all] }
  let(:iat) { Time.now.to_i }
  let(:expiry) { Time.now.to_i + 86_400 }

  let(:payload) do
    described_class.new domain: domain,
                        sub: sub,
                        audience: audience,
                        azp: azp,
                        scheme: scheme,
                        scopes: scopes,
                        iat: iat,
                        expiry: expiry
  end

  it "#initialize" do
    expect(payload).to be_an_instance_of described_class
  end

  it "#to_h works" do
    expect(payload.to_h).to be_an_instance_of Hash
    puts JSON.pretty_generate payload.to_h
  end

  describe "Create a token with the payload" do
    let(:jwt_secret) { ENV.fetch("STUDIO_DEV_AUTH0_CLIENT_SECRET") }
    let(:jwt_algorithm) { ENV["STUDIO_JWT_ALGORITHM"] }

    let(:token) { JWT.encode payload.to_h, jwt_secret, jwt_algorithm, { typ: "JWT", kid: SecureRandom.hex } }

    let(:header) do
      {
        "Content-Type" => "application/json",
        "Cache-Control" => "no-cache",
        "Application" => "Bearer #{token}",
        "User-Agent" => Studio::Graphql.configuration.user_agent
      }
    end

    it "#creates token" do
      puts token
      expect(token).to be_an_instance_of String
    end
  end
end
# rubocop:enable  Metrics/BlockLength
