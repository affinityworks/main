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
    #this can't be the right way to do this = rabble
    @events = Event.all if params[:id] == 'events'
    @event = Event.find(params[:id]) if @events.nil? && params[:id].kind_of?(Fixnum)


    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::EventsRepresenter.for_collection.new(Event.add_attendance_counts(@events)).to_json if @events
        render json: JsonApi::EventRepresenter.new(@event).to_json if @event
      end
    end
  end


  private

  def events
    @events = Event.all
  end

end
