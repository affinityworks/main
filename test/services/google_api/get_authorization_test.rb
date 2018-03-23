require_relative "../../test_helper"

class GoogleAPI::GetAuthorizationTest < ActiveSupport::TestCase
  describe ".call" do
    it "calls build_directory_service" do
      expect(GoogleAPI::GetAuthorization).to receive(:get_authorization)

      GoogleAPI::GetAuthorization.call(
        network: double("network")
      )
    end

    it "returns correct authorizer sub" do
      auth = GoogleAPI::GetAuthorization.call(
        network: Network.new(name: "Swing Left Network")
      )

      auth.sub.must_equal "james@affinity.works"
    end

    it "returns correct authorizer scope" do
      auth = GoogleAPI::GetAuthorization.call(
        network: Network.new(name: "Swing Left Network")
      )

      auth.scope.must_equal GoogleAPI::GetAuthorization::SCOPES
    end
  end
end
