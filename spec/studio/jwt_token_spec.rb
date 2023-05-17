# frozen_string_literal: true

require_relative "./jwt_token/shared_configuration"

# rubocop:disable Metrics/BlockLength
RSpec.describe Studio::JwtToken do
  include_context "shared configuration"

  let(:payload) { { "key" => "value" } }
  let(:jwt_token) { described_class.encode(payload) }

  let(:new_value) { "new value" }
  let(:payload) { { artist: "Michelangelo" } }

  it "#configure works" do
    described_class.configure do |config|
      config.comment = new_value
    end
    expect(described_class.configuration.comment).to eq new_value
  end

  describe ".decode" do
    let(:jwt_token) { described_class.encode(payload) }

    it "decodes additional parameters" do
      expect(described_class.decode(jwt_token).first.keys).to include "artist"
    end
  end

  describe "HS256 with auth0 token" do
    let(:kid) { "2H3C1XHcQalcG1m3Bonth" }
    let(:public_key) { fixtures_path "#{kid}.pem" }

    let(:secret) do
      "MzYwMCwiYXpwIjoiNmRjODI5MGQxMzZkM2M4O"
    end

    let(:payload) { { artist: "Michelangelo" } }

    let(:jwt_token) do
      described_class.encode payload, secret: secret, algorithm: "HS256", kid: SecureRandom.hex
    end

    let(:decoded) do
      described_class.decode jwt_token, secret: secret, algorithm: "HS256"
    end

    it "#encode X" do
      expect(jwt_token).to be_a_kind_of(String)
      puts jwt_token
    end

    it "#decode X" do
      expect(decoded).to be_a_kind_of(Array)
      puts decoded
    end
  end
end
# rubocop:enable Metrics/BlockLength
