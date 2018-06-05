class Members::AfterCreate
  class << self
    def call(member:, group:)
      GroupMailer.join_group_email(member, group).deliver_later

      if StaticFeatureToggle.on?(:google_groups, group)
        GoogleGroupJobs::
          AddNewMemberToGroupJob.perform_later(member: member, group: group)
      end
    end
  end
end
