RSpec.describe Foobara::AuthHttp::ClearAccessTokenHeader do
  let(:request) do
    Foobara::CommandConnectors::Http::Request.new(path: "/whatever")
  end
  let(:response) do
    Foobara::CommandConnectors::Http::Response.new(
      request:,
      headers: { "X-Access-Token" => "foo" }
    )
  end

  let(:mutator) { described_class.new }

  it "sets the X-Access-Token header to nil" do
    expect {
      mutator.mutate(response)
    }.to change(response, :headers).from("X-Access-Token" => "foo").to("X-Access-Token" => nil)
  end
end
