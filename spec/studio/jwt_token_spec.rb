# frozen_string_literal: true

RSpec.describe Studio::JwtToken do
  let(:auth_token) { "auth_token-value" }

  let(:jwt_token) { described_class.jwt_encode(auth_token: auth_token) }

  let(:new_value) { "new value" }

  before do
    described_class.configure auth_token:
  end

  it "#configure works" do
    described_class.configure do |config|
      config.jwt_hmac_secret = new_value
    end
    expect(described_class.configuration.jwt_hmac_secret).to eq new_value
  end

  it "#auth_token returns String" do
    expect(described_class.auth_token).to be_an_instance_of String
  end

  it "#auth_token_match? returns true" do
    expect(described_class.auth_token_match?(jwt_token)).to be true
  end

  it "#generate_jwt_token" do
    expect(described_class.generate_jwt_token).to be_an_instance_of String
  end

  context "when auth_token is not set" do
    let(:auth_token) { nil }
    it "#auth_token_match? returns false" do
      expect(described_class.auth_token_match?(jwt_token)).to be false
    end
  end

  context "when jwt_token is invalid" do
    let(:jwt_token) { "invalid format" }
    it "#auth_token_match? raises Studio::JwtToken::Invalid " do
      expect { described_class.auth_token_match?(jwt_token) }.to raise_error(Studio::JwtToken::Invalid)
    end
  end

  context "when auth_token is not matching" do
    let(:auth_token) { "auth_token-different-value" }

    it "#auth_token_match! raises Studio::JwtToken::MatchError " do
      expect { described_class.auth_token_match!(jwt_token) }.to raise_error(Studio::JwtToken::MatchError)
    end
  end

  describe "with additional parameters (payload)" do
    let(:jwt_token) { described_class.generate_jwt_token(artist: "Michelangelo") }

    it "decodes additional parameters" do
      expect(described_class.jwt_decode(jwt_token).first.keys).to include "artist"
    end
  end
end
