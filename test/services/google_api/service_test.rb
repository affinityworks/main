require_relative "../../test_helper"

class GoogleAPI::ServiceTest < ActiveSupport::TestCase
  let(:network_double){ double(Network, google_gsuite_key_path: 'foo/bar') }
  let(:authorization_double){ double("auth") }
  let(:directory_service_double){ double("directory_service") }
  let(:google_group_double){ double("g_group",  id: 'foo', email: 'foo@bar.com') }

  describe "#authenticate" do
    describe "when auth succeeds" do
      before do
        allow(GoogleAPI::GetAuthorization)
          .to receive(:call)
                .and_return(double(:success? => true, :result => authorization_double))
        allow(GoogleAPI::BuildDirectoryService)
          .to receive(:call).and_return(directory_service_double)

        @service = GoogleAPI::Service.new
                     .authenticate(network: network_double)
      end

      it "sets @authorization" do
        @service.authorization.must_equal authorization_double
      end

      it "sets @directory_service" do
        @service.directory_service.must_equal directory_service_double
      end
    end

    describe "when auth fails" do
      before do
        allow(GoogleAPI::GetAuthorization)
          .to receive(:call).and_return(double(:success? => false))
        allow(GoogleAPI::BuildDirectoryService).to receive(:call)

        @service = GoogleAPI::Service.new
                     .authenticate(network: network_double)
      end

      it "does not set @authorization" do
        @service.authorization.must_be_nil
      end

      it "does not set @directory_service" do
        @service.directory_service.must_be_nil
      end

      it "does not try to build directory service" do
        expect(GoogleAPI::BuildDirectoryService)
          .not_to have_received(:call)
      end
    end
  end

  describe "#create_google_group" do
    describe "when when auth has occured" do
      before do
        allow(GoogleAPI::CreateGoogleGroup)
          .to receive(:call).and_return(google_group_double)
        allow(GoogleAPI::UpdateGoogleGroupSettings)
          .to receive(:call)

        @service = GoogleAPI::Service
                     .new(authorization: authorization_double,
                          directory_service: directory_service_double)
                     .authenticate(network: network_double)
                     .create_google_group(email: '', name: '')
      end

      it "sets @google_group" do
        @service.google_group.must_equal google_group_double
      end

      it "updates group settings" do
        expect(GoogleAPI::UpdateGoogleGroupSettings)
          .to have_received(:call).with(
                authorization: authorization_double,
                google_group: google_group_double
              )
      end
    end

    describe "when auth has not occured" do
      before do
        allow(GoogleAPI::CreateGoogleGroup)
          .to receive(:call)
        allow(GoogleAPI::UpdateGoogleGroupSettings)
          .to receive(:call)

        @service = GoogleAPI::Service
                     .new
                     .create_google_group(email: '', name: '')
      end

      it "does not set @google_group" do
        @service.google_group.must_be_nil
      end

      it "does not try to create google group" do
        expect(GoogleAPI::CreateGoogleGroup).not_to have_received(:call)
      end

      it "does not update group settings" do
        expect(GoogleAPI::UpdateGoogleGroupSettings).not_to have_received(:call)
      end
    end

    describe "when google group creation fails" do
      before do
        allow(GoogleAPI::CreateGoogleGroup)
          .to receive(:call).and_return(nil)
        allow(GoogleAPI::UpdateGoogleGroupSettings)
          .to receive(:call)

        @service = GoogleAPI::Service
                     .new(authorization: authorization_double,
                          directory_service: directory_service_double)
                     .authenticate(network: network_double)
                     .create_google_group(email: '', name: '')
      end

      it "does not set @google_group" do
        @service.google_group.must_be_nil
      end

      it "does not update group settings" do
        expect(GoogleAPI::UpdateGoogleGroupSettings)
          .not_to have_received(:call)
      end
    end
  end

  describe "#save_google_group" do
    describe "when @google_group has been set" do
      before do
        allow(GoogleGroup).to receive(:create!)
        @service = GoogleAPI::Service
                     .new(google_group: google_group_double)
                     .save_google_group(group: double(Group))
      end


      it "saves a representation of the google group to the db" do
        expect(GoogleGroup).to have_received(:create!)
      end
    end

    describe "when @google_group is nil" do
      before do
        allow(GoogleGroup).to receive(:create!)
        @service = GoogleAPI::Service
                     .new(google_group: nil)
                     .save_google_group(group: double(Group))
      end

      it "does not try to save the google group to the db" do
        expect(GoogleGroup).not_to have_received(:create!)
      end
    end
  end

  describe "#fetch_google_group" do
    describe "when directory service exists" do
      before do
        allow(GoogleAPI::FetchGoogleGroup)
          .to receive(:call).and_return(google_group_double)
        @service = GoogleAPI::Service
                     .new(directory_service: directory_service_double)
                     .fetch_google_group(group_key: "foo")
      end


      it "fetches the google group" do
        allow(GoogleAPI::FetchGoogleGroup)
          .to receive(:call).with(directory_service: directory_service_double,
                                  group_key: "foo")
      end

      it "sets @google_group" do
        @service.google_group.must_equal google_group_double
      end
    end

    describe "when directory service has not been set" do
      before do
        allow(GoogleAPI::FetchGoogleGroup).to receive(:call)
        @service = GoogleAPI::Service
                     .new(directory_service: nil)
                     .fetch_google_group(group_key: "foo")
      end

      it "does not try to fetch google group" do
        expect(GoogleAPI::FetchGoogleGroup).not_to have_received(:call)
      end
    end

    describe "when group_key is nil" do
      before do
        allow(GoogleAPI::FetchGoogleGroup).to receive(:call)
        GoogleAPI::Service
          .new(directory_service: directory_service_double)
          .fetch_google_group(group_key: nil)
      end

      it "does not try to fetch google group" do
        expect(GoogleAPI::FetchGoogleGroup).not_to have_received(:call)
      end
    end
  end

  describe "#add_member_to_google_group" do
    describe "when auth has occured an google group exists" do
      before do
        allow(GoogleAPI::AddMemberToGoogleGroup).to receive(:call)
        @service = GoogleAPI::Service
                     .new(directory_service: directory_service_double,
                          google_group: google_group_double)
                     .add_member_to_google_group(email: 'foo', role: 'bar')
      end

      it "adds member to google group" do
        expect(GoogleAPI::AddMemberToGoogleGroup)
          .to have_received(:call)
                .with(directory_service: directory_service_double,
                      google_group: google_group_double,
                      email: 'foo',
                      role: 'bar')
      end
    end

    describe "when auth has not occured" do
      before do
        allow(GoogleAPI::AddMemberToGoogleGroup).to receive(:call)
        @service = GoogleAPI::Service
                     .new(directory_service: nil, google_group: google_group_double)
                     .add_member_to_google_group(email: 'foo', role: 'bar')
      end

      it "does not try to add member to google group" do
        expect(GoogleAPI::AddMemberToGoogleGroup).not_to have_received(:call)
      end
    end

    describe "when google group has not been set" do
      before do
        allow(GoogleAPI::AddMemberToGoogleGroup).to receive(:call)
        @service = GoogleAPI::Service
                     .new(directory_service: directory_service_double, google_group: nil)
                     .add_member_to_google_group(email: 'foo', role: 'bar')
      end

      it "does not try to add member to google group" do
        expect(GoogleAPI::AddMemberToGoogleGroup).not_to have_received(:call)
      end
    end
  end
end
