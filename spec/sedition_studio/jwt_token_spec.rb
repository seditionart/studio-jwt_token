# frozen_string_literal: true

RSpec.describe SeditionStudio::JwtToken do
  let(:auth_token) { "auth_token-value" }

  let(:jwt_token) { described_class.jwt_encode(auth_token: auth_token) }

  before do
    described_class.configure
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

  describe "with additional parameters (payload)" do
    let(:jwt_token) { described_class.generate_jwt_token(artist: "Michelangelo") }

    it "decodes additional parameters" do
      expect(described_class.jwt_decode(jwt_token).first.keys).to include "artist"
    end
  end
end
