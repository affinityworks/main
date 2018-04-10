require 'google/apis/admin_directory_v1'

class GoogleAPI::AddMemberToGoogleGroup
  class << self
    def call(authorization:, google_group:, email:, role:)
      directory_service = build_directory_service(authorization)
      add_member_to_google_group(directory_service, google_group, email, role)
    end

    private

    def build_directory_service(authorization)
      GoogleAPI::BuildDirectoryService.call(authorization: authorization)
    end


    def add_member_to_google_group(directory_service, google_group, email, role)
      member = Google::Apis::AdminDirectoryV1::Member.new(email: email, role: role)

      directory_service.insert_member(google_group.id, member)
    end
  end
end
