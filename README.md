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
Studio::JwtToken.configure
```

With auth_token only

```ruby
Studio::JwtToken.generate_jwt_token
```

With auth_token and additional payload

```ruby
Studio::JwtToken.generate_jwt_token scope: 'artworks', artist: 'Jack Reacher'
```

### Get Payload

```ruby
Studio::JwtToken.jwt_token_payload(jwt_token)
```

### Compare auth_token with local

```ruby
Studio::JwtToken.auth_token_match?(jwt_token)
```

The following raises `Studio::JwtToken::MatchError` if the auth tokens don't math.

```ruby
Studio::JwtToken.auth_token_match!(jwt_token)
```

## Example client request header

* Using default configuration (`Studio::JwtToken.configuration`) for this example.

```ruby
def header
  {
    "Content-Type" => "application/json",
    "Cache-Control" => "no-cache",
    Studio::JwtToken::DEFAULT_HEADER_NAME => "Bearer #{Studio::JwtToken.generate_jwt_token}",
    "User-Agent" => Studio::Graphql.configuration.user_agent
  }
end
```

## Testing

Copy source .env.sample to .env.test.

```bash
bundle exec rspec
```

## Author

Eugen
