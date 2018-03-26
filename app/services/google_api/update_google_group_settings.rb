require 'google/apis/groupssettings_v1'

class GoogleAPI::UpdateGoogleGroupSettings
  class << self
    def call(authorization:, google_group:)
      update_google_group_settings(authorization, google_group)
    end

    private

    def update_google_group_settings(authorization, google_group)
      group_settings = Google::Apis::GroupssettingsV1::Groups.new(allow_external_members: "true", is_archived: "true")
      settings_service = Google::Apis::GroupssettingsV1::GroupssettingsService.new
      settings_service.authorization = authorization

      settings_service.update_group(google_group.email, group_settings)
    end
  end
end