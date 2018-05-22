class Subgroups::AfterCreate
  class << self
    def call(organizer:, subgroup:)
      GroupMailer.join_group_email(organizer, subgroup).deliver_later

      if FeatureToggle.on?(:google_groups, subgroup)
        # TODO (aguestuser|11 Ap 2018):
        # do this in a job; network calls take several seconds
        GoogleAPI::Service.new
          .authenticate(network: subgroup.primary_network)
          .create_google_group(email: subgroup.build_google_group_email, name: subgroup.name)
          .save_google_group(group: subgroup)
          .add_member_to_google_group(email: organizer.email, role: GoogleAPI::Roles::OWNER)
      end
    end
  end
end
