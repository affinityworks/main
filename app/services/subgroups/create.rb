class Subgroups::Create
  class << self
    def call(organizer:, subgroup:)
      OrganizerMailer
        .new_subgroup_email(organizer, subgroup, SignupForm.for(subgroup))
        .deliver_later

      if FeatureToggle.on?(:google_groups, @subgroup)
        authorization = GoogleAPI::GetAuthorization.call(network: subgroup.primary_network)

        google_group = GoogleAPI::CreateGoogleGroup.call(
          authorization: authorization,
          group_email: subgroup.google_group_email,
          group_name: subgroup.name
        )

        GoogleAPI::UpdateGoogleGroupSettings.call(
          authorization: authorization,
          google_group: google_group
        )
        
        GoogleAPI::AddMemberToGoogleGroup.call(
          authorization: authorization,
          google_group: google_group,
          email: organizer.email
        )
      end
    end
  end
end