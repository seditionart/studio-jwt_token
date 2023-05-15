# frozen_string_literal: true

RSpec.describe Studio::JwtToken do
  let(:payload) { { "key" => "value" } }
  let(:jwt_token) { described_class.jwt_encode(payload) }

  let(:new_value) { "new value" }

  before do
    described_class.configure
  end

  it "#configure works" do
    described_class.configure do |config|
      config.jwt_hmac_secret = new_value
    end
    expect(described_class.configuration.jwt_hmac_secret).to eq new_value
  end

  it "#generate without payload" do
    expect(described_class.generate).to be_an_instance_of String
  end

  describe "with additional parameters (payload)" do
    let(:payload) { { artist: "Michelangelo" } }
    let(:jwt_token) { described_class.generate(payload) }

    it "decodes additional parameters" do
      expect(described_class.decode(jwt_token).first.keys).to include "artist"
    end
  end
end
