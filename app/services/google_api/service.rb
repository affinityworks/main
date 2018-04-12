class GoogleAPI::Service
  include GoogleAPI
  attr_reader :authorization, :directory_service, :google_group

  def initialize(args = {})
    @authorization = args[:authorization]         # Google::Auth::ServiceAccountCredentials
    @directory_service = args[:directory_service] # Google::Apis::AdminDirectoryV1::DirectoryService
    @google_group = args[:google_group]           # Google::Apis::AdminDirect%%%%%oryV1::Group
  end

  # Network => GoogleAPI::Service
  def authenticate(network:)
    service = GetAuthorization.call(network: network)
     return self unless service.success?
     @authorization = service.result
     build_directory_service
     self
  end

  # (String, String) => GoogleAPI::Service
  def create_google_group(email:, name:)
    return self unless @authorization && @directory_service
    @google_group = CreateGoogleGroup.call(
      directory_service: @directory_service,
      group_email:       email,
      group_name:        name
    )
    update_google_group_settings
    self
  end

  # (Group) => GoogleAPI::Service
  def save_google_group(group:)
    return self unless @google_group
    GoogleGroup.create!(
      group:     group,
      group_key: @google_group.id,
      email:     @google_group.email,
      url:       GoogleGroup.url_from(@google_group.email),
    )
    self
  end

  # (String) => GoogleAPI::Service
  def fetch_google_group(group_key:)
    return self unless @directory_service && group_key
    @google_group = FetchGoogleGroup.call(
      directory_service: @directory_service,
      group_key: group_key
    )
    self
  end

  # (String, String) -> GoogleAPI::Service
  def add_member_to_google_group(email:, role:)
    return self unless @directory_service && @google_group
    AddMemberToGoogleGroup.call(
      directory_service: @directory_service,
      google_group:      @google_group,
      email:             email,
      role:              role
    )
    self
  end

  private

  # () => Void
  def build_directory_service
    return unless @authorization
    @directory_service = BuildDirectoryService.call(authorization: @authorization)
  end


  # () => Void
  def update_google_group_settings
    return unless @authorization && @google_group
    UpdateGoogleGroupSettings.call(
      authorization: @authorization,
      google_group:  @google_group
    )
  end
end
