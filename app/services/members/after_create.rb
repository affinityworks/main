class Members::AfterCreate
  class << self
    def call(member:, group:)
      # TODO (aguestuser|10 Apr 2018): we should probably send a welcome email?
      if FeatureToggle.on?(:google_groups, group)
        GoogleGroupJobs::
          AddNewMemberToGroupJob.perform_later(member: member, group: group)
      end
    end
  end
end
