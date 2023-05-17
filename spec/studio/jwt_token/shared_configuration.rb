# frozen_string_literal: true

RSpec.shared_context "shared configuration" do
  let(:public_key) { fixtures_path "public_key.pem" }
  let(:private_key) { fixtures_path "private_key.pem" }

  # let(:configuration) do
  #   described_class.new public_key: public_key,
  #                       private_key: private_key
  # end

  before do
    Studio::JwtToken.configure do |config|
      config.secret = "secret"
      config.public_key = public_key
      config.private_key = private_key
    end
  end
end

# before do
#   unless File.exist?("private_key.pem")
#     key = OpenSSL::PKey::RSA.generate(2048)
#     rsa_private_key = File.open("private_key.pem", "w") { |f| f.write key.to_pem }
#     rsa_public_key = File.open("public_key.pem", "w") { |f| f.write key.public_key.to_pem }
#   end

#   Studio::JwtToken.configure private_key: rsa_private_key
# end
