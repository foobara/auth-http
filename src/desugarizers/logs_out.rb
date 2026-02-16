module Foobara
  module AuthHttp
    module Desugarizers
      class LogsOut < CommandConnectors::Desugarizer
        def applicable?(args_and_opts)
          args_and_opts.last[:logs_out]
        end

        def desugarize(args_and_opts)
          args, opts = args_and_opts

          opts = opts.merge(
            request_mutators: Foobara::AuthHttp::SetRefreshTokenFromCookie,
            response_mutators: Foobara::AuthHttp::ClearAccessTokenHeader
          )

          opts.delete(:logs_out)

          [args, opts]
        end
      end
    end
  end
end
