module Foobara
  module AuthHttp
    class ClearAccessTokenHeader < Foobara::CommandConnectors::Http::SetHeader
      # TODO: move this into base class as default?
      class << self
        def requires_declaration_data?
          false
        end
      end

      def initialize(header_name = "X-Access-Token", header_value = nil)
        super()

        self.header_name = header_name.to_s
        self.header_value = header_value
      end
    end
  end
end
