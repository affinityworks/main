class EventsController < ApplicationController
  before_action :authenticate_person!

  before_action :set_events, only: :index
  before_action :set_event, only: :show

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: {
          events: JsonApi::EventsRepresenter.for_collection.new(Event.add_attendance_counts(@events)),
          total_pages: @events.total_pages,
          page: @events.current_page
        }.to_json
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

    @events = @events.page(params[:page])
  end

  def set_event
    @event = current_group.events.find(params[:id])
  end
end
