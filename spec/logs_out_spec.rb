RSpec.describe Foobara::AuthHttp::Desugarizers::LogsOut do
  let(:connector) do
    Foobara::CommandConnectors::Http.new
  end
  let(:command_class) do
    stub_class("Logout", Foobara::Command)
  end

  before do
    connector.connect(command_class, :logs_out)
  end

  it "sets a request and response mutator" do
    expect(connector.lookup_command(:Logout).request_mutators).to eq(Foobara::AuthHttp::SetRefreshTokenFromCookie)
    expect(connector.lookup_command(:Logout).response_mutators).to eq(Foobara::AuthHttp::ClearAccessTokenHeader)
  end
end
