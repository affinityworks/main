class GoogleAPI::GetAuthorization
  attr_accessor :result, :error

  SCOPES = [
    'https://www.googleapis.com/auth/admin.directory.group',
    'https://www.googleapis.com/auth/admin.directory.group.member',
    'https://www.googleapis.com/auth/apps.groups.settings'
  ].freeze

  def initialize(network:)
    @network = network
    @success = nil
    @result = nil
    @error = ""
  end

  def call
    tap { get_authorization(@network) }
  end

  def success?
    @success
  end

  def success!(authorizer)
    @success = true
    @result = authorizer
  end

  def fail!
    @success = false
    @error = "Failed to authorize successfully, ensure that valid credential file exists."
  end

  def get_authorization(network)
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(network.google_gsuite_key),
      scope: SCOPES
    )
    
    authorizer.sub = network.google_gsuite_admin_email
    success!(authorizer)
  rescue
    fail!
  end

  class << self
    def call(network:)
      new(network: network).call
    end
  end
end