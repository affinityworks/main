class GoogleAPI::ListMembersInGoogleGroup
  class << self
    # (Google::Apis::AdminDirectoryV1::DirectoryService, String)
    # => Google::Apis::AdminDirectoryV1::Group
    def call(directory_service:, google_group:)
      directory_service.list_members(google_group.id)
    end
  end
end
