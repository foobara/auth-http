module Foobara
  module AuthHttp
    class MoveAccessTokenToHeader < Foobara::CommandConnectors::Http::MoveAttributeToHeader
      # TODO: move this into base class as default?
      class << self
        def requires_declaration_data?
          false
        end
      end

      def initialize(attribute_name = :access_token, header_name = "X-Access-Token")
        super()

        self.attribute_name = attribute_name
        self.header_name = header_name
      end
    end
  end
end
