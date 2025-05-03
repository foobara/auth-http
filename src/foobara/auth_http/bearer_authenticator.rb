module Foobara
  module AuthHttp
    class BearerAuthenticator < CommandConnector::Authenticator
      class << self
        def load_user(**, &block)
          new(**, load_user: block)
        end
      end

      def initialize(load_user: nil, relevant_entity_classes: Auth::Types::User, **)
        @load_user = load_user || ->(user_id) { Auth::FindUser.run!(id: user_id) }
        @relevant_entity_classes = relevant_entity_classes

        super(symbol: :bearer,
              explanation: "Expects an access token in authorization header in format of: Bearer <token>",
              **)
      end

      def applicable?(request)
        request.headers.key?("authorization")
      end

      def block
        return @block if @block

        authenticator = self

        @block = proc do
          token = authenticator.extract_token_from_headers(headers)

          if token
            user_id = authenticator.verify_access_token(token)

            if user_id
              authenticator.load_user_record(user_id)
            end
          end
        end
      end

      def extract_token_from_headers(headers)
        token = headers["authorization"]
        token&.gsub(/^Bearer\s+/, "")&.strip
      end

      def verify_access_token(token)
        verification_and_payload = Foobara::Auth::VerifyAccessToken.run!(access_token: token)

        if verification_and_payload[:verified]
          verification_and_payload[:payload]["sub"]
        end
      end

      def load_user_record(user_id)
        if user_id
          @load_user.call(user_id)
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
