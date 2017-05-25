class Facebook::Event
  FACEBOOK_DOMAIN = 'facebook.com'
  EVENT_ID_REGEXP = /facebook\.com\/events\/(?<event_id>\w+)/

  def initialize(identity)
    @identity = identity
    @options = { access_token: @identity.access_token }
    @api_agent = Facebook::ApiAgent.new
  end

  def all
    @api_agent.get("/#{@identity.uid}/events", @options)
  end

  def find(event_data)
    @api_agent.get("/#{get_event_id(event_data)}", @options)
  rescue
    nil
  end

  private

  def get_event_id(event_data)
    if event_data.include?(FACEBOOK_DOMAIN)
      event_data.match(EVENT_ID_REGEXP)['event_id']
    else
      event_data
    end
  end
end
