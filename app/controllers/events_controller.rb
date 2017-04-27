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

    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::EventRepresenter.new(@event).to_json if @event
      end
    end
  end


  private

  def events
    params[:filter] ? Event.where('title ilike ?',"%#{params[:filter]}%") : Event.all
  end

end
