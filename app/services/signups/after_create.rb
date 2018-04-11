class Signups::AfterCreate
  class << self
    def call(member:, group:)
      # TODO (aguestuser|10 Apr 2018): we should probably send a welcome email?

      if FeatureToggle.on?(:google_groups, group)
        # TODO (aguestuser|10 Apr 2018):
        # - EXTRACT ALL THIS!!!
        # - perform in a job!!!

        service = GoogleAPI::GetAuthorization.call(network: group.primary_network) 
        return unless service.success?
        authorization = service.result

        google_group = GoogleAPI::FetchGoogleGroup.call(
          authorization: authorization,
          group_key: group.google_group_key
        )

        GoogleAPI::AddMemberToGoogleGroup.call(
          authorization: authorization,
          google_group: google_group,
          email: member.email,
          role: GoogleAPI::Roles::MEMBER
        )

        # TODO (aguestuser|10 Apr 2018):
        # - to be able to remove users from google group later
        # - we would need to persist a GoogleGroupMembership here
        # - and store the Google::Apis::AdminDirectoryV1::Member.id on it
      end
    end
  end
end
