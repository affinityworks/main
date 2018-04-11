require_relative "../../test_helper"

class GoogleAPI::CreateGoogleGroupTest < ActiveSupport::TestCase
  describe ".call" do
    let(:directory_service_double){ double(Google::Apis::GroupssettingsV1::Groups) }
    let(:google_group_double){ double(Google::Apis::AdminDirectoryV1::Group) }

    before do
      allow(Google::Apis::AdminDirectoryV1::Group)
        .to receive(:new).and_return(google_group_double)
      allow(directory_service_double)
        .to receive(:insert_group).and_return(google_group_double)

      GoogleAPI::CreateGoogleGroup.call(
        directory_service: directory_service_double,
        group_email: "foo@bar.com",
        group_name: "The Foos"
      )
    end

    it "constructs a new google group" do
      expect(Google::Apis::AdminDirectoryV1::Group)
        .to have_received(:new)
              .with(email: "foo@bar.com",
                    name: "The Foos",
                    description: GoogleAPI::CreateGoogleGroup::DESCRIPTION)
    end

    it "inserts the google group into the directory service" do
      expect(directory_service_double)
        .to have_received(:insert_group).with(google_group_double)
    end
  end
end
