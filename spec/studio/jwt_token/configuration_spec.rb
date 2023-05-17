# frozen_string_literal: true

require "spec_helper"

RSpec.describe Studio::JwtToken::Configuration do
  let(:public_key) { fixtures_path "public_key.pem" }
  let(:private_key) { fixtures_path "private_key.pem" }

  let(:configuration) do
    described_class.new public_key: public_key,
                        private_key: private_key,
                        secret: "secret"
  end

  it "#initialize" do
    expect(configuration).to be_an_instance_of(described_class)
  end

  it "#secret" do
    expect(configuration.secret).to be_an_instance_of(String)
  end
end
