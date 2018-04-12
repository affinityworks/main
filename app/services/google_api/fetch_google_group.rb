class GoogleAPI::FetchGoogleGroup
  class << self
    # (Google::Apis::AdminDirectoryV1::DirectoryService, String)
    # => Google::Apis::AdminDirectoryV1::Group
    def call(directory_service:, group_key:)
      directory_service.get_group(group_key)
    end
  end
end
