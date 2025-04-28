module Foobara
  module AuthHttp
    class MoveRefreshTokenToCookie < Foobara::CommandConnectors::Http::MoveAttributeToCookie
      # TODO: move this into base class as default?
      class << self
        def requires_declaration_data?
          false
        end
      end

      def initialize(attribute_name = :refresh_token, cookie_name = attribute_name, **cookie_opts)
        super()

        self.attribute_name = attribute_name.to_sym
        self.cookie_name = cookie_name.to_s
        self.cookie_opts = {
          httponly: true,
          path: "/run/Foobara/Auth/",
          secure: ENV["FOOBARA_ENV"] != "development" && ENV["FOOBARA_ENV"] != "test",
          same_site: :strict
        }.merge(cookie_opts)
      end
    end
  end
end
