# Studio::JwtToken

## About

Encode/decode an app auth token via JWT.

* https://github.com/jwt/ruby-jwt

## Installation

Include gem

```ruby
gem 'studio-jwt_token', '~> 1.1 ', git: 'https://github.com/seditionart/studio-jwt_token.git'
```

## Usage

Include the gem in both applications with identical configuration.

### Configuration (based on Rails credentails)

* defined a key `jwt_token` for this example

Create an initializer `studio_auth.rb`

```ruby
Studio::JwtToken.config do |config|
  config.algorithm = Rails.application.credentials.jwt_token[:algorithm]
  config.private_key = ...
  config.public_key = ...
  config.secret = ...
  config.domain = ...
  config.audience = ...
end
```

There is also the option to overwrite all/some of the parameters through environment variables:

* STUDIO_JWT_ALGORITHM

#### For RS2456

* STUDIO_JWT_PRIVATE_KEY
  * RSA private key
  * can be key or path to key file
  * required on client side
* STUDIO_JWT_PUBLIC_KEY
  * RSA public key
  * can be key or path to key file
  * required on server

#### For HS2456

* STUDIO_JWT_SECRET
  * can be key of path to key file

#### Payload

* STUDIO_JWT_AUTH0_DOMAIN
* STUDIO_JWT_AUTH0_AUDIENCE


See .env.example for more details.


### Create token


## Example client request header

* Using default configuration (`Studio::JwtToken.configuration`) for this example.

### A sample header for the Cleint

```ruby
# @return [Hash]
def header
  token = Studio::JwtToken::Payload.new(
    domain: "seditionart-dev.eu.auth0.com",
    audience: "dev/graphql"
  ).token

  {
    "Content-Type" => "application/json",
    "Cache-Control" => "no-cache",
    "Application => "Bearer #{token}",
    "User-Agent" => 'Website xyz'
  }
end
```

## Testing

```bash
bundle exec rspec
```

With DEBUG set test prints additional info like token's, etc.

## Author

Eugen
