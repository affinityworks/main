class GoogleAPI::FetchGoogleGroup
  class << self
    # (Google::Auth::ServiceAccountCredentials, String)
    # => Google::Apis::AdminDirectoryV1::Group
    def call(authorization:, group_key:)
      GoogleAPI::
        BuildDirectoryService
        .call(authorization: authorization)
        .get_group(group_key)
    end
  end
end
