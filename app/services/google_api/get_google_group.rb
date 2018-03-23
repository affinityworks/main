class GoogleAPI::GetGoogleGroup
  class << self
    def call(authorization:, group_email:)
      directory_service = build_directory_service(authorization)
      get_google_group(directory_service, group_email)
    end

    private

    def build_directory_service(authorization)
      GoogleAPI::BuildDirectoryService.call(authorization: authorization)
    end

    def get_google_group(directory_service, group_email)
      directory_service.get_group(group_email)
    end
  end
end