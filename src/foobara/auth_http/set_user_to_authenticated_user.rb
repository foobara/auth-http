module Foobara
  module AuthHttp
    # Is this genuinely a generic enough concept to be a class in this project?
    class SetUserToAuthenticatedUser < Foobara::CommandConnectors::Http::SetInputToProcResult
      # TODO: move this into base class as default?
      class << self
        def requires_declaration_data?
          false
        end
      end

      def initialize
        self.attribute_name = :user
        self.input_value_proc = proc { authenticated_user }

        super
      end
    end
  end
end
