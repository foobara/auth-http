RSpec.describe Foobara::AuthHttp::ApiKeyAuthenticator do
  after { Foobara.reset_alls }

  before do
    Foobara::Persistence.default_crud_driver = Foobara::Persistence::CrudDrivers::InMemory.new
  end

  let(:authenticator) { described_class.new }

  let(:user) do
    Foobara::Auth::Register.run!(username: "Barbara", email: "barbara@example.com", plaintext_password: "1234")
  end
  let(:api_key) do
    Foobara::Auth::CreateApiKey.run!(user: user.id)
  end

  it "has a symbol and explanation" do
    expect(authenticator.symbol).to eq(:api_key)
    expect(authenticator.explanation).to match(/api.?key/i)
  end

  context "when logged in and running a command requiring authentication" do
    let(:command_connector) do
      Foobara::CommandConnectors::Http.new(authenticator:).tap do |connector|
        connector.connect(command_class, requires_authentication: true)
      end
    end
    let(:command_class) do
      stub_class("HelloWorld", Foobara::Command) do
        def execute
          "Hello, World!"
        end
      end
    end

    let(:path) { "/run/HelloWorld" }
    let(:headers) do
      {
        "x-api-key" => api_key
      }
    end

    it "runs the command" do
      response = command_connector.run(path:, headers:)

      # TODO: add a #authenticated_user method to Response and Request
      expect(response.command.authenticated_user).to be_a(Foobara::Auth::Types::User)
    end

    context "when using the registered symbol for the authenticator" do
      let(:authenticator) { :api_key }

      it "runs the command" do
        response = command_connector.run(path:, headers:)

        # TODO: add a #authenticated_user method to Response and Request
        expect(response.command.authenticated_user).to be_a(Foobara::Auth::Types::User)
      end
    end

    context "with a bad token" do
      let(:api_key) do
        super()
        "bad token"
      end

      it "does not give an authenticated user" do
        response = command_connector.run(path:, headers:)

        # TODO: add a #authenticated_user method to Response and Request
        expect(response.command.authenticated_user).to be_nil
        # TODO: add more convenience methods for accessing this stuff?
        expect(response.request.outcome.errors_hash.keys).to eq(["runtime.unauthenticated"])
      end
    end
  end

  describe ".load_user" do
    let(:authenticator) do
      user = some_user_object

      described_class.load_user do |_user_id|
        user
      end
    end
    let(:some_user_object) { Object.new }

    let(:request) do
      Foobara::CommandConnectors::Http::Request.new(
        path: "/whatever",
        headers: { "x-api-key" => api_key }
      )
    end
    let(:user_and_credential) { authenticator.authenticate(request) }
    let(:loaded_user) { user_and_credential.first }
    let(:credential) { user_and_credential.last }

    it "can load a custom user object" do
      expect(loaded_user).to eq(some_user_object)
      expect(credential).to be_a(Foobara::Auth::Types::Token)
    end
  end
end
