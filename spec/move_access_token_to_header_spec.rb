RSpec.describe Foobara::AuthHttp::MoveAccessTokenToHeader do
  let(:request) do
    Foobara::CommandConnectors::Http::Request.new(path: "/whatever")
  end
  let(:response) do
    Foobara::CommandConnectors::Http::Response.new(
      request:,
      body: {
        access_token: "abc123",
        foo: "bar"
      }
    )
  end

  let(:mutator) { described_class.new }

  it "sets the X-Access-Token header and removes it from the response body" do
    mutator.mutate(response)

    expect(response.headers["X-Access-Token"]).to eq("abc123")
    expect(response.body).to eq(foo: "bar")
  end
end
