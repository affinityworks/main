require 'google/apis/admin_directory_v1'

class GoogleAPI::AddMemberToGoogleGroup
  class << self
    # (Google::Apis::AdminDirectoryV1::DirectoryService
    #  Google::Apis::AdminDirectoryV1::Group,
    #  String,
    #  String)
    #  => Google::Apis::AdminDirectoryV1::Member
    def call(directory_service:, google_group:, email:, role:)
      member = Google::Apis::AdminDirectoryV1::Member.new(email: email, role: role)
      directory_service.insert_member(google_group.id, member)
    end
  end
end
