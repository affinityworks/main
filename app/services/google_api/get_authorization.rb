class GoogleAPI::GetAuthorization
  attr_accessor :result, :error

  SCOPES = [
    'https://www.googleapis.com/auth/admin.directory.group',
    'https://www.googleapis.com/auth/admin.directory.group.member',
    'https://www.googleapis.com/auth/apps.groups.settings'
  ].freeze

  def initialize(network:)
    @network = network # Network
    @success = nil     # Boolean
    @result = nil      # Google::Auth::ServiceAccountCredentials
    @error = ""        # String
  end

  # Network -> Void
  def call
    tap { get_authorization(@network) }
  end

  def success?
    @success
  end

  def success!(authorization)
    @success = true
    @result = authorization
  end

  def fail!
    @success = false
    @error = "Failed to authorize successfully, ensure that valid credential file exists."
  end

  def get_authorization(network)
    authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(network.google_gsuite_key_path),
      scope: SCOPES
    )

    authorization.sub = network.google_gsuite_admin_email
    success!(authorization)
  rescue
    fail!
  end

  class << self
    def call(network:)
      new(network: network).call
    end
  end
end
