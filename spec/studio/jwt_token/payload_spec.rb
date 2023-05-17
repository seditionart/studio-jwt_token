# frozen_string_literal: true

require "securerandom"
require_relative "./shared_configuration"

# rubocop:disable  Metrics/BlockLength
RSpec.describe Studio::JwtToken::Payload do
  include_context "shared configuration"

  # Using
  let(:domain) { "seditionart-dev.eu.auth0.com" }
  let(:sub) { "auth0|0" }
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

  it "#token works" do
    expect(payload.token).to be_an_instance_of String
    puts "--- TOKEN -----------------"
    puts payload.token
  end

  describe "RS256" do
    let(:algorithm) { "RS256" }

    let(:rsa_key) { OpenSSL::PKey::RSA.generate 2048 }

    let(:token) do
      Studio::JwtToken.encode payload.to_h, secret: rsa_key, algorithm: algorithm, kid: SecureRandom.hex
    end

    let(:decoded) do
      Studio::JwtToken.decode token, secret: rsa_key.public_key, algorithm: algorithm
    end

    let(:header) do
      {
        "Content-Type" => "application/json",
        "Cache-Control" => "no-cache",
        "Application" => "Bearer #{token}",
        "User-Agent" => Studio::Graphql.configuration.user_agent
      }
    end

    it "#creates token" do
      expect(token).to be_an_instance_of String
      puts "-- TOKEN ----------------- "
      puts token
      puts rsa_key.to_pem
      puts rsa_key.public_key.to_pem
    end

    it "decodes" do
      expect(decoded).to be_an_instance_of Array
    end
  end
end
# rubocop:enable  Metrics/BlockLength
