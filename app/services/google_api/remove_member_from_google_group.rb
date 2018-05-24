require 'google/apis/admin_directory_v1'

class GoogleAPI::RemoveMemberFromGoogleGroup
  class << self
    # (Google::Apis::AdminDirectoryV1::DirectoryService
    #  Google::Apis::AdminDirectoryV1::Group,
    #  String)
    #  => Google::Apis::AdminDirectoryV1::Member
    def call(directory_service:, google_group:, email:)
      directory_service.delete_member(google_group.id, email)
    end
  end
end
