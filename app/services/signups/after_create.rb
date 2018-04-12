class Signups::AfterCreate
  class << self
    def call(member:, group:)
      # TODO (aguestuser|10 Apr 2018): we should probably send a welcome email?
      if FeatureToggle.on?(:google_groups, group)
        # TODO (aguestuser|10 Apr 2018): perform in a job!!!
        GoogleAPI::Service.new
          .authenticate(network: group.primary_network)
          .fetch_google_group(group_key: group.google_group_key)
          .add_member_to_google_group(email: member.email,
                                      role: GoogleAPI::Roles::MEMBER)
      end
    end
  end
end
