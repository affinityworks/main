class Subgroups::Create
  class << self
    def call(organizer:, subgroup:)
      OrganizerMailer
        .new_subgroup_email(organizer, subgroup, SignupForm.for(subgroup))
        .deliver_later

      if FeatureToggle.on?(:google_groups, subgroup)
        # TODO (aguestuser|30 Mar 2018)
        # - these api calls should probably happen in a job
        # - they cause form to hang for several seconds before submit success
        # - also: consider creating a wrapper class to encapsulate state
        #   and replace below calls with 0-argument chained method calls
        service = GoogleAPI::GetAuthorization.call(network: subgroup.primary_network) 

        return unless service.success?

        authorization = service.result

        google_group = GoogleAPI::CreateGoogleGroup.call(
          authorization: authorization,
          group_email: subgroup.google_group_email,
          group_name: subgroup.name
        )

        # TODO: extract this! (along with everything else in this long-ass function!)
        GoogleGroup.create!(
          group: subgroup,
          group_key: google_group.non_editable_aliases.first,
          email: google_group.email,
          url: GoogleGroup.url_from(google_group.email),
        )

        GoogleAPI::UpdateGoogleGroupSettings.call(
          authorization: authorization,
          google_group: google_group
        )

        GoogleAPI::AddMemberToGoogleGroup.call(
          authorization: authorization,
          google_group: google_group,
          email: organizer.email,
          role: GoogleAPI::Roles::OWNER
        )
      end
    end
  end
end
