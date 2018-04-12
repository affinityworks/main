require_relative "../../test_helper"

class GoogleAPI::GetAuthorizationTest < ActiveSupport::TestCase
  describe ".call" do
    let(:network){ networks(:national_network) }
    let(:credentials_double){ double(File) }
    let(:authorization_double) do
      double(Google::Auth::ServiceAccountCredentials,
             scopes: GoogleAPI::GetAuthorization::SCOPES)
    end

    before do
      # for most cases, assume credentials reading works
      allow(File)
        .to receive(:open).and_return(credentials_double)
      allow(File)
        .to receive(:closed?).and_return(true)
    end

    describe "when authentication succeeds" do
      before do
        allow(Google::Auth::ServiceAccountCredentials)
          .to receive(:make_creds).and_return(authorization_double)
        allow(authorization_double)
          .to receive(:sub=)

        @auth_service = GoogleAPI::GetAuthorization.call(network: network)
      end

      it "reads credentials from disk" do
        expect(File)
          .to have_received(:open).with(network.google_gsuite_key_path)
      end

      it "constructs an authorization object" do
        expect(Google::Auth::ServiceAccountCredentials)
          .to have_received(:make_creds).with(
                json_key_io: credentials_double,
                scope: GoogleAPI::GetAuthorization::SCOPES
              )
      end

      it "sets the sub on the authorization object" do
        expect(authorization_double)
          .to have_received(:sub=).with(network.google_gsuite_admin_email)
      end

      it "returns success status" do
        @auth_service.success?.must_equal true
      end

      it "returns authorization object as result" do
        @auth_service.result.must_equal authorization_double
      end
    end

    describe "when credentials can't be found" do
      before do
        allow(File).to receive(:open).and_raise("BOOM!")
        @auth_service = GoogleAPI::GetAuthorization.call(network: network)
      end

      it "returns failure status" do
        @auth_service.success?.must_equal false
      end
    end

    describe "when authentication fails" do
      before do
        allow(Google::Auth::ServiceAccountCredentials)
          .to receive(:make_creds).and_raise("oh noes!")
        @auth_service = GoogleAPI::GetAuthorization.call(network: network)
      end

      it "returns failure status" do
        @auth_service.success?.must_equal false
      end
    end
  end
end
