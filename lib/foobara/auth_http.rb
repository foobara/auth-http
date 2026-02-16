require "foobara/all"
require "foobara/http_command_connector"
require "foobara/auth"

module Foobara
  module AuthHttp
    foobara_domain!

    class << self
      def install!
        CommandConnectors::Http.register_authenticator BearerAuthenticator
        CommandConnectors::Http.register_authenticator ApiKeyAuthenticator
        CommandConnectors::Http.add_desugarizer Desugarizers::LogsOut
      end
    end
  end
end

Foobara::Util.require_directory "#{__dir__}/../../src"
Foobara.project "auth_http", project_path: "#{__dir__}/../../"
