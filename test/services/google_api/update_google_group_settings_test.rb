require_relative "../../test_helper"

class GoogleAPI::UpdateGoogleGroupSettingsTest < ActiveSupport::TestCase
  describe ".call" do
    let(:authorization_double){ double(Google::Auth::ServiceAccountCredentials) }
    let(:directory_service_double){ double(Google::Apis::GroupssettingsV1::Groups) }
    let(:google_group_double){ double(Google::Apis::AdminDirectoryV1::Group, email: 'foo@bar.com') }
    let(:group_settings_double){ double(Google::Apis::GroupssettingsV1::Groups) }
    let(:settings_service_double){ Google::Apis::GroupssettingsV1::GroupssettingsService }

    before do
      allow(Google::Apis::GroupssettingsV1::Groups)
        .to receive(:new).and_return(group_settings_double)
      allow(Google::Apis::GroupssettingsV1::GroupssettingsService)
        .to receive(:new).and_return(settings_service_double)
      allow(settings_service_double)
        .to receive(:authorization=)
      allow(settings_service_double)
        .to receive(:update_group)

      GoogleAPI::UpdateGoogleGroupSettings.call(
        authorization: authorization_double,
        google_group: google_group_double
      )
    end

    it "constructs permissive group settings object" do
      expect(Google::Apis::GroupssettingsV1::Groups)
        .to have_received(:new).with(allow_external_members: 'true',
                                     is_archived: 'true') # hmm.. 'true'?
    end

    it "authorizes the settings service" do
      expect(settings_service_double)
        .to have_received(:authorization=).with(authorization_double)
    end

    it "updates the group with the new settings" do
      expect(settings_service_double)
        .to have_received(:update_group).with(google_group_double.email,
                                              group_settings_double)
    end
  end
end
