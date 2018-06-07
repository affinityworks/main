class Memberships::AfterDestroy
  class << self
    def call(member:, group:)
      if StaticFeatureToggle.on?(:google_groups, group)
        GoogleGroupJobs::
          RemoveMemberFromGroupJob.perform_later(member: member, group: group)
      end
    end
  end
end
