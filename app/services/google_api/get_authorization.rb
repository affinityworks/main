class GoogleAPI::GetAuthorization
  class << self
    def call(network:)
      get_authorization(network)
    end

    private

    def get_authorization(network)
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(network.google_gsuite_key),
        scope: auth_scopes,
        sub: network.google_gsuite_admin_email
      )
      
      authorizer.sub = network.google_gsuite_admin_email
      authorizer
    end

    def auth_scopes
      [
        'https://www.googleapis.com/auth/admin.directory.group',
        'https://www.googleapis.com/auth/admin.directory.group.member',
        'https://www.googleapis.com/auth/apps.groups.settings'
      ]
    end
  end
end