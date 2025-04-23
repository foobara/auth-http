# Foobara::AuthHttp

Contains helper classes/methods for exposing Foobara::Auth over HTTP

<!-- TOC -->
* [Foobara::AuthHttp](#foobaraauthhttp)
  * [Installation](#installation)
  * [Usage](#usage)
    * [Rack example](#rack-example)
    * [Rails example](#rails-example)
  * [Contributing](#contributing)
  * [License](#license)
<!-- TOC -->

## Installation

Typical stuff: add `gem "foobara-auth-http"` to your Gemfile or .gemspec file. Or even just
`gem install foobara-auth-http` if just playing with it directly in scripts.

## Usage

### Rack example

TODO

### Rails example

Here's an example of using AuthHttp helpers in a Rails app to expose various Foobara::Auth commands over HTTP
and put them to use:

```ruby
require "foobara/rails_command_connector"
require "foobara/auth_http"

authenticator = Foobara::AuthHttp::BearerAuthenticator

Foobara::CommandConnectors::RailsCommandConnector.new(authenticator:)
require "foobara/rails/routes"

login_response_mutators = [
  Foobara::AuthHttp::MoveRefreshTokenToCookie.new(secure: Rails.env.production?),
  Foobara::AuthHttp::MoveAccessTokenToHeader
]

Rails.application.routes.draw do
  command Foobara::Auth::Register,
          inputs_transformers: Foobara::AttributesTransformers.only(:username, :email, :plaintext_password)

  command Foobara::Auth::Login,
          inputs_transformers: Foobara::AttributesTransformers.only(:username_or_email, :plaintext_password),
          response_mutators: login_response_mutators

  command Foobara::Auth::RefreshLogin,
          request_mutators: Foobara::AuthHttp::SetRefreshTokenFromCookie,
          inputs_transformers: Foobara::AttributesTransformers.only(:refresh_token),
          response_mutators: login_response_mutators

  command Foobara::Auth::Logout,
          request_mutators: Foobara::AuthHttp::SetRefreshTokenFromCookie,
          response_mutators: Foobara::AuthHttp::ClearAccessTokenHeader

  command CreateBlogPost,
          requires_authentication: true

  command EditBlogPost,
          requires_authentication: true,
          allowed_rule: -> { blog_post.owned_by?(authenticated_user) }

  # whatever other routes you need/want
end
```

A rundown of everything happening here:

* We are declaring that we want to authenticate using bearer tokens. These are JWT tokens in an
  `Authorization: Bearer <token>` header.
* We are declaring that when we login or refresh our login, we would like to move the new access token
  from the result to an X-Access-Token header, and we would like
  to move the new refresh token from the result to a secure http only cookie.
* We are declaring that when we want to refresh our login, we want to move the refresh token from the
  headers to an input to RefreshLogin.
* Logout could technically be handled by the client but for convenience/added safety, we expose
  Logout and move the refresh token to its inputs so that it can invalidate the refresh token.
* When we respond from Logout, we set the X-Access-Token header to nil. This is something the client
  could do but gives an easy way to clobber the client's access token without effort on their end.

We also expose a few app commands using our authenticator. This is configured as part of command connectors not
the foobara-auth domain nor this gem but included here as an example.

The inputs transformers are just convenience items to simplify any clients that import our exposed commands
to simplify their interfaces and any forms they feel like generating.

## Contributing

Bug reports and pull requests are welcome on GitHub
at https://github.com/foobara/auth-http

## License

This project is dual licensed under your choice of the Apache-2.0 license and the MIT license.
Please see LICENSE.txt for more info.
