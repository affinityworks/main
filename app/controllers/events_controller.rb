class EventsController < ApplicationController
  before_action :authenticate_request!
  #load_and_authorize_resource

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::EventsRepresenter.for_collection.new(Event.add_attendance_counts(events)).to_json
      end
    end
  end

  def show
    @event = Event.find(params[:id])

    event_with_attendance = Event.add_attendance_counts([@event]).first

    event_with_attendance = Event.add_attendance_counts([@event]).first if @event

    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::EventRepresenter.new(event_with_attendance).to_json
      end
    end
  end


  private

  def events
    @events = Event.includes(:location)

    if params[:filter] then
      @events = @events.where('title ilike ?',"%#{params[:filter]}%")
    end

    @events
  end

  def authenticate_request!
    osdi_api_token = request.headers['HTTP_OSDI_API_TOKEN'] || params[:osdi_api_token]

    if osdi_api_token.present?
      api_user = Api::User.first_by_osdi_api_token(osdi_api_token)

      sign_in api_user, store: false if api_user
    else
      authenticate_person!
    end
  end
end
