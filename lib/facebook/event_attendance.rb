class Facebook::EventAttendance
  def initialize(identity, event_id)
    @identity = identity
    @event_id = event_id
    @options = { access_token: @identity.access_token }
    @api_agent = Facebook::ApiAgent.new
  end

  #NOTE we need to add API pagination
  def attendances
    (attending + interested + maybe).uniq
  end

  def attending
    @api_agent.get("/#{@event_id}/attending", @options)['data']
  end

  def declined
    @api_agent.get("/#{@event_id}/declined", @options)['data']
  end

  def interested
    @api_agent.get("/#{@event_id}/interested", @options)['data']
  end

  def maybe
    @api_agent.get("/#{@event_id}/maybe", @options)['data']
  end
end
