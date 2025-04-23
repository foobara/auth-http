RSpec.describe Foobara::AuthHttp::MoveRefreshTokenToCookie do
  let(:request) do
    Foobara::CommandConnectors::Http::Request.new(path: "/whatever")
  end
  let(:response) do
    Foobara::CommandConnectors::Http::Response.new(
      request:,
      body: {
        refresh_token: "abc123",
        foo: "bar"
      }
    )
  end

  let(:mutator) { described_class.new }

  it "moves the refresh_token to the response cookies" do
    expect(response.body).to eq(refresh_token: "abc123", foo: "bar")
    expect(response.cookies).to eq([])

    mutator.mutate(response)

    expect(response.cookies.size).to eq(1)

    cookie = response.cookies.first

    expect(cookie.name).to eq(:refresh_token)
    expect(cookie.value).to eq("abc123")
    expect(response.body).to eq(foo: "bar")
  end
end
