require 'google/apis/admin_directory_v1'

class GoogleAPI::BuildDirectoryService
  class << self
    def call(authorization:)
      build_directory_service(authorization)
    end

    def build_directory_service(authorization)
      directory_service = Google::Apis::AdminDirectoryV1::DirectoryService.new
      directory_service.authorization = authorization

      directory_service
    end
  end
end