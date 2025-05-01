RSpec.describe Foobara::AuthHttp::SetUserToAuthenticatedUser do
  let(:command) do
    instance_double(Foobara::TransformedCommand, authenticated_user:)
  end
  let(:authenticated_user) { Object.new }
  let(:request) do
    Foobara::CommandConnectors::Http::Request.new(
      path: "/whatever"
    ).tap { |r| r.command = command }
  end

  let(:mutator) { described_class.new }

  it "fills in the refresh_token input from the cookie" do
    expect {
      mutator.mutate(request)
    }.to change(request, :inputs).from({}).to(user: authenticated_user)
  end
end
