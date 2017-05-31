class Facebook::Authorization
  def initialize(identity)
    @identity = identity
    @options = { grant_type: 'fb_exchange_token',
      client_id: ENV["FACEBOOK_APP_ID"],
      client_secret: ENV["FACEBOOK_APP_SECRET"],
      fb_exchange_token: @identity.access_token
    }
    @api_agent = Facebook::ApiAgent.new
  end

  def request_long_lived_token
    @api_agent.get('/oauth/access_token', @options)['access_token']
  rescue
    @identity.access_token
  end
end
