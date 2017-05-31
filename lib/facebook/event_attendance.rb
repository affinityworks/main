class Facebook::EventAttendance
  def initialize(identity, event_id)
    @identity = identity
    @event_id = event_id
    @options = { access_token: @identity.access_token }
    @api_agent = Facebook::ApiAgent.new
  end

  def attending
    @api_agent.get("/#{@event_id}/attending", @options)
  end

  def declined
    @api_agent.get("/#{@event_id}/declined", @options)
  end

  def interested
    @api_agent.get("/#{@event_id}/interested", @options)
  end

  def maybe
    @api_agent.get("/#{@event_id}/maybe", @options)
  end
end
