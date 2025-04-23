module Foobara
  module AuthHttp
    class SetRefreshTokenFromCookie < Foobara::CommandConnectors::Http::SetInputFromCookie
      # TODO: move this into base class as default?
      class << self
        def requires_declaration_data?
          false
        end
      end

      def initialize(attribute_name = :refresh_token, cookie_name = attribute_name)
        super()

        self.attribute_name = attribute_name
        self.cookie_name = cookie_name
      end
    end
  end
end
