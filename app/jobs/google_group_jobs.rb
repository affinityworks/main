class GoogleGroupJobs
  class AddNewMemberToGroupJob < ApplicationJob
    def perform(member:, group:)
      GoogleAPI::Service.new
        .authenticate(network: group.primary_network)
        .fetch_google_group(group_key: group.google_group_key)
        .add_member_to_google_group(email: member.email,
                                    role: GoogleAPI::Roles::MEMBER)
    end
  end
end
