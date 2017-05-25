class ImportsController < ApplicationController
  before_action :authenticate_person!
  before_action :validate_facebook_auth

  def find
    identity = current_person.identities.facebook.first
    remote_event = Facebook::Event.new(identity).find(params[:remote_event_url])
    start_date = remote_event['start_time'] if remote_event

    respond_to do |format|
      format.html
      format.json do
        render json: {
          remote_event: remote_event,
          events: JsonApi::EventsRepresenter.for_collection.new(current_group.events.start(start_date))
        }.to_json
      end
    end
  end

  private

  def validate_facebook_auth
    redirect_to events_url unless current_person.identities.facebook.any?
  end
end
