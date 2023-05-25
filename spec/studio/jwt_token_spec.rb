# frozen_string_literal: true

require_relative "./jwt_token/shared_configuration"

# rubocop:disable Metrics/BlockLength
RSpec.describe Studio::JwtToken do
  include_context "shared configuration"

  let(:payload) { { "key" => "value" } }
  let(:jwt_token) { described_class::Payload.new(payload).token }

  let(:new_value) { "new value" }
  let(:payload) { { scheme: "https" } }

  it "#configure works" do
    described_class.configure do |config|
      config.comment = new_value
    end
    expect(described_class.configuration.comment).to eq new_value
  end

  describe ".decode" do
    let(:jwt_token) { described_class::Payload.new(payload).token }

    it "decodes additional parameters" do
      expect(described_class.decode(jwt_token).first.keys).to include(*%w[iss sub aud iat exp azp
                                                                          scope])
    end
  end

  describe "HS256 with auth0 token" do
    let(:kid) { "2H3C1XHcQalcG1m3Bonth" }
    let(:public_key) { fixtures_path "#{kid}.pem" }

    let(:secret) do
      "MzYwMCwiYXpwIjoiNmRjODI5MGQxMzZkM2M4O"
    end

    let(:payload) { { scheme: "https" } }

    let(:jwt_token) do
      described_class.encode payload, secret: secret, algorithm: "HS256", kid: SecureRandom.hex
    end

    let(:decoded) do
      described_class.decode jwt_token, secret: secret, algorithm: "HS256"
    end

    it "#encode returns String" do
      expect(jwt_token).to be_a_kind_of(String)
      puts jwt_token if ENV["DEBUG"]
    end

    it "#decode returns Array" do
      expect(decoded).to be_a_kind_of(Array)
      puts decoded if ENV["DEBUG"]
    end
  end
end
# rubocop:enable Metrics/BlockLength
