# frozen_string_literal: true

require_relative "lib/studio/jwt_token/version"

Gem::Specification.new do |spec|
  spec.name = "studio-jwt_token"
  spec.version = Studio::JwtToken::VERSION
  spec.authors = ["Eugen"]
  spec.email = ["eh.gh@ardelconcepts.com"]

  spec.summary = "Studio JWT authentication."
  spec.description = "Studio JWT authentication."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://github.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "jwt", ">= 1.4", "< 3.0"
  spec.add_dependency "openssl", ">= 2.1", "< 3.0"
  spec.add_development_dependency "pry", "~> 0.13"
  spec.add_development_dependency "pry-byebug", "~> 3.9"
end
