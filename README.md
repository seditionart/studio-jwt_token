# SeditionStudio::JwtToken

## About

Encode/decode an app auth token via JWT.

* https://github.com/jwt/ruby-jwt

## Installation

Include gem

```ruby
gem 'sedition_studio-jwt_token', '~> 0.2 ', git: 'https://github.com/seditionart/sedition_studio-jwt_token.git'
```

## Usage

Include the gem in both applications with identical configuration.

### Configuration (based on Rails credentails)

* defined a key `jwt_token` for this example

Create an initializer `studio_auth.rb`

```ruby
SeditionStudio::JwtToken.config do |config|
  config.jwt_algorithm = Rails.application.credentials.jwt_token[:jwt_algorithm]
  config.jwt_hmac_secret = Rails.application.credentials.jwt_token[:jwt_hmac_secret]
  config.auth_token = Rails.application.credentials.jwt_token[:auth_token]
  config.payload = Rails.application.credentials.jwt_token[:payload]
end
```

There is also the option to overwrite all/some of the parameters through environment variables:

* STUDIO_JWT_HMAC_SECRET
* STUDIO_JWT_ALGORITHM
* STUDIO_AUTH_TOKEN : the shared access token

```ruby
SeditionStudio::JwtToken.config
```

With auth_token only

```ruby
SeditionStudio::JwtToken.generate_jwt_token
```

With auth_token and additional payload

```ruby
SeditionStudio::JwtToken.generate_jwt_token scope: 'artworks', artist: 'Jack Reacher'
```

### Get Payload

```ruby
SeditionStudio::JwtToken.jwt_token_payload(jwt_token)
```

### Compare auth_token with local

```ruby
SeditionStudio::JwtToken.auth_token_match?(jwt_token)
```

## Testing

```bash
source .env.sample
bundle exec rspec
```

## Author

Eugen