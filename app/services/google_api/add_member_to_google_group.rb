require 'google/apis/admin_directory_v1'

class GoogleAPI::AddMemberToGoogleGroup
  class << self
    def call(authorization:, google_group:, email:)
      directory_service = build_directory_service(authorization)
      add_member_to_google_group(directory_service, google_group, email)
    end

    private

    def build_directory_service(authorization)
      GoogleAPI::BuildDirectoryService.call(authorization: authorization)
    end


    def add_member_to_google_group(directory_service, group, email)
      member = Google::Apis::AdminDirectoryV1::Member.new(email: email, role: "OWNER")

      directory_service.insert_member(group.id, member)
    end
  end
end