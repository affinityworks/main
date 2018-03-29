require_relative "../../test_helper"

class GoogleAPI::GetAuthorizationTest < ActiveSupport::TestCase
  describe ".call" do

    # TODO: (aguestuser|29 Mar 2018)
    # - these tests make un-mocked/stubbed calls to the google api
    #   (via `Google::Auth::ServiceAccountCredentials.make_creds` at `get_authorization.rb:36`)
    # - as such, they must look for and find a valid credentials file
    #   on their local file system and make a network call in order to pass
    # - currenly we satisfy that criteria by allowthing them to look for
    #   `lib/network_credentials/7af65312214cfedd28371a29af1c6f22/google_gsuite_key.json`
    #   (which is always encrypted and gitignored, and thus safe)
    # - however, that means these tests can never pass on travis unless we
    #   encrypte them to a private key that we also store on travis, or expose
    #   our gsuite credentials, both of which seem undesirable
    # - a better strategy might be to
    #   (1) provide a dummy plaintext credentials file (for "Foo Network")
    #   (2) stub the call to `Google::Auth::ServiceAccountCredentials.make_creds`
    # - leaving as a TODO for now, pending further discussion w/ @vaughan10

    before do
      network = Network.create(name: "Foo Network")
      #network = networks(:national_network)
      @auth_service = GoogleAPI::GetAuthorization.new(network: network)
    end

    it "calls build_directory_service" do
      expect(@auth_service).to receive(:get_authorization)

      @auth_service.call
    end

    it "returns correct authorizer sub" do
      @auth_service.call

      @auth_service.result.sub.must_equal "james@affinity.works"
    end

    it "returns correct authorizer scope" do
      @auth_service.call

      @auth_service.result.scope.must_equal GoogleAPI::GetAuthorization::SCOPES
    end

    it "returns with success status if Network has credentials file" do
      @auth_service.call

      @auth_service.success?.must_equal true
    end

    it "returns with fail status if Network has no credentials file" do
      auth_service = GoogleAPI::GetAuthorization.call(network: Network.new(name: "Bad Network"))

      auth_service.success?.must_equal false
    end
  end
end
