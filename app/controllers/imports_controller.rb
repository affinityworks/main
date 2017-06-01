class ImportsController < ApplicationController
  before_action :authenticate_person!
  before_action :validate_facebook_auth

  protect_from_forgery except: [:create, :create_facebook_attendance, :delete_facebook_attendance] #TODO: Add the csrf token in react.

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
    facebook_event = FacebookEvent.find_or_initialize_for_event(params[:event_id], params[:remote_event])
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
    matches = current_group.members.map_with_remote_rsvps(remote_attendances)

    respond_to do |format|
      format.html
      format.json do
        render json: matches.to_json
      end
    end
  end

  def create_facebook_attendance
    event = FacebookEvent.find(params[:remote_event_id]).event
    member = current_group.members.find(params[:person_id])
    member.add_identifier('facebook', params[:facebook_id])

    attendance = member.attendances.find_or_initialize_by(event_id: event.id).tap do |attendance|
      attendance.origins.push(Origin.facebook)
      attendance.invited_by_id ||= current_user.id
      attendance.status ||= 'tentative'
    end

    member.save!
  end

  def delete_facebook_attendance
    event = FacebookEvent.find(params[:remote_event_id]).event
    member = current_group.members.find(params[:person_id])
    member.remove_identifier('facebook')
    attendance = member.attendances.find_by(event_id: event.id)
    attendance.origins.delete(Origin.facebook)

    attendance.delete if attendance.origins.empty?

    member.save!
  end

  private

  def validate_facebook_auth
    redirect_to events_url unless current_person.identities.facebook.any?
  end
end
