require_relative "../../test_helper"

class GoogleAPI::GetAuthorizationTest < ActiveSupport::TestCase
  describe ".call" do

    before do
      network = Network.new(name: "National Network")
      @auth_service = GoogleAPI::GetAuthorization.new(network: network)
    end

    it "calls build_directory_service" do
      skip
      expect(@auth_service).to receive(:get_authorization)

      @auth_service.call
    end

    it "returns correct authorizer sub" do
      skip
      @auth_service.call

      @auth_service.result.sub.must_equal "james@affinity.works"
    end

    it "returns correct authorizer scope" do
      skip
      @auth_service.call

      @auth_service.result.scope.must_equal GoogleAPI::GetAuthorization::SCOPES
    end

    it "returns with success status if Network has credentials file" do
      skip
      @auth_service.call

      @auth_service.success?.must_equal true
    end

    it "returns with fail status if Network has no credentials file" do
      auth_service = GoogleAPI::GetAuthorization.call(network: Network.new(name: "Bad Network"))

      auth_service.success?.must_equal false
    end
  end
end
