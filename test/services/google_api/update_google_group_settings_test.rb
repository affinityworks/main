require_relative "../../test_helper"

class GoogleAPI::UpdateGoogleGroupSettingsTest < ActiveSupport::TestCase
  describe ".call" do
    it "calls update_google_group_settings" do
      expect(GoogleAPI::UpdateGoogleGroupSettings).to receive(:update_google_group_settings)
      
      GoogleAPI::UpdateGoogleGroupSettings.call(
        authorization: double("auth"),
        google_group: double("google_group")
      )
    end

    it "calls update_group on settings service" do
      settings_service = double("settings service")
      auth = 'auth'
      email = "test@group.com"
      google_group = instance_double("google group", email: email)

      allow(Google::Apis::GroupssettingsV1::GroupssettingsService).to receive(:new).and_return(settings_service)
      allow(settings_service).to receive(:authorization=).with(auth)
      expect(settings_service).to receive(:update_group)
      
      GoogleAPI::UpdateGoogleGroupSettings.call(
        authorization: auth,
        google_group: google_group
      )
    end
  end
end
