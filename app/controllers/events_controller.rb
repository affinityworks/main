class EventsController < ApplicationController
  before_action :authenticate_request!

  before_action :set_events, only: :index
  before_action :set_event, only: :show


  def index
    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::EventsRepresenter.for_collection.new(Event.add_attendance_counts(@events)).to_json
      end
    end
  end

  def show
    event_with_attendance = Event.add_attendance_counts([@event]).first

    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::EventRepresenter.new(event_with_attendance).to_json
      end
    end
  end


  private

  def set_events
    @events = current_group.events.includes(:location)

    if params[:filter] then
      @events = @events.where('title ilike ?',"%#{params[:filter]}%")
    end
  end

  def set_event
    @event = current_group.events.find(params[:id])
  end

  def authenticate_request!
    osdi_api_token = request.headers['HTTP_OSDI_API_TOKEN'] || params[:osdi_api_token]

    if osdi_api_token.present?
      api_user = Api::User.first_by_osdi_api_token(osdi_api_token)

      sign_in :person, api_user, store: false if api_user
    else
      authenticate_person!
    end
  end
end
