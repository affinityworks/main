class EventsController < ApplicationController
  before_action :authenticate_person!
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
end
