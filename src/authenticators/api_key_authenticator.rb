module Foobara
  module AuthHttp
    class ApiKeyAuthenticator < CommandConnector::Authenticator
      class << self
        def load_user(**, &block)
          new(**, load_user: block)
        end
      end

      def initialize(load_user: nil, relevant_entity_classes: Auth::Types::User, **)
        @relevant_entity_classes = relevant_entity_classes

        if load_user
          @load_user = load_user
        end

        super(
          symbol: :api_key,
          explanation: "Expects an api key to be passed in the x-api-key header",
          **
        )
      end

      def applicable?(request)
        request.headers.key?("x-api-key")
      end

      def block
        @block ||= begin
          load_user_block = @load_user

          proc do
            api_key = headers["x-api-key"]

            outcome = Foobara::Auth::AuthenticateWithApiKey.run(api_key:)

            if outcome.success?
              user, credential = outcome.result

              if load_user_block
                user = load_user_block.call(user.id)
              end

              [user, credential]
            end
          end
        end
      end

      def relevant_entity_classes(request)
        if applicable?(request)
          @relevant_entity_classes
        end
      end
    end
  end
end
