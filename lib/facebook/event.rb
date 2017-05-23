class Facebook::Event
  def initialize(identity)
    @identity = identity
    @options = { access_token: @identity.access_token }
    @api_agent = Facebook::ApiAgent.new
  end

  def all
    @api_agent.get("/#{@identity.uid}/events", @options)
  end

  def find(event_id)
    @api_agent.get("/#{event_id}", @options)
  end
end
