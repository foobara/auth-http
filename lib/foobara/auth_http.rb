require "foobara/all"
require "foobara/http_command_connector"
require "foobara/auth"

module Foobara
  module AuthHttp
    foobara_domain!

    class << self
      def install!
        CommandConnectors::Http.register_authenticator(BearerAuthenticator)
      end
    end
  end
end

Foobara::Util.require_directory "#{__dir__}/../../src"
Foobara::Monorepo.project "auth_http", project_path: "#{__dir__}/../../"
