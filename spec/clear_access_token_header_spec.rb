RSpec.describe Foobara::AuthHttp::ClearAccessTokenHeader do
  let(:request) do
    Foobara::CommandConnectors::Http::Request.new(path: "/whatever")
  end
  let(:response) do
    Foobara::CommandConnectors::Http::Response.new(
      request:,
      headers: { "x-access-token" => "foo" }
    )
  end

  let(:mutator) { described_class.new }

  it "sets the x-access-token header to nil" do
    expect {
      mutator.mutate(response)
    }.to change(response, :headers).from("x-access-token" => "foo").to("x-access-token" => nil)
  end
end
