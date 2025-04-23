RSpec.describe Foobara::AuthHttp::SetRefreshTokenFromCookie do
  let(:request) do
    Foobara::CommandConnectors::Http::Request.new(
      path: "/whatever",
      cookies: { refresh_token: "abc123" }
    )
  end

  let(:mutator) { described_class.new }

  it "fills in the refresh_token input from the cookie" do
    expect {
      mutator.mutate(request)
    }.to change(request, :inputs).from({}).to(refresh_token: "abc123")
  end
end
