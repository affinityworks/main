require_relative "../../test_helper"

class GoogleAPI::AddMemberToGoogleGroupTest < ActiveSupport::TestCase
  describe ".call" do
    let(:directory_service_double){ double(Google::Apis::GroupssettingsV1::Groups) }
    let(:google_group_member_double){ double(Google::Apis::AdminDirectoryV1::Member) }
    let(:google_group_double){ double(Google::Apis::AdminDirectoryV1::Group, id: 1) }

    before do
      allow(Google::Apis::AdminDirectoryV1::Member)
        .to receive(:new).and_return(google_group_member_double)
      allow(directory_service_double)
        .to receive(:insert_member).and_return(google_group_member_double)

      GoogleAPI::AddMemberToGoogleGroup.call(
        directory_service: directory_service_double,
        google_group: google_group_double,
        email: "foo@bar.com",
        role: "OWNER"
      )
    end

    it "constructs a new google group member" do
      expect(Google::Apis::AdminDirectoryV1::Member)
        .to have_received(:new).with(email: "foo@bar.com", role: "OWNER")
    end

    it "inserts the member into the google group" do
      expect(directory_service_double)
        .to have_received(:insert_member).with(google_group_double.id,
                                               google_group_member_double)
    end
  end
end
