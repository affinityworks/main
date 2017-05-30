class ImportsController < ApplicationController
  before_action :authenticate_person!
  before_action :validate_facebook_auth

  protect_from_forgery except: [:create] #TODO: Add the csrf token in react.

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

  def create
    facebook_event = FacebookEvent.initialize_for_event(params[:event_id], params[:remote_event])
    respond_to do |format|
      format.json do
        if facebook_event.save
          render json: {
            id: facebook_event.id
          }
        else
          render json: facebook_event.errors.full_messages, status: 422
        end
      end
    end
  end

  def attendances
    remote_event = RemoteEvent.find(params[:remote_event_id])
    remote_attendances = remote_event.attendances(current_person.identities.facebook.first)
    respond_to do |format|
      format.html
      format.json do
        render json: current_group.members.map_with_remote_rsvps(remote_attendances).to_json
      end
    end
  end

  def matching
  end

  private

  def validate_facebook_auth
    redirect_to events_url unless current_person.identities.facebook.any?
  end
end
