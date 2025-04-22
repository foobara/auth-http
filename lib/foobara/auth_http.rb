require "foobara/all"
require "foobara/http_command_connector"
require "foobara/auth"

Foobara::Util.require_directory "#{__dir__}/../../src"

module Foobara
  module AuthHttp
    class << self
      def install!
        CommandConnectors::Http.register_authenticator(BearerAuthenticator)
      end
    end
  end
end

Foobara::Monorepo.project "auth_http", project_path: "#{__dir__}/../../"
