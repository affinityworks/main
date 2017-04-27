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
    @event = Event.find(params[:id]) unless params[:id] == 'events'

    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::EventRepresenter.new(@event).to_json if @event
        render json: JsonApi::EventsRepresenter.for_collection.new(Event.add_attendance_counts(events)).to_json if params[:id] == 'events'
      end
    end
  end


  private

  def events
    if params[:filter] then
     return Event.where('title ilike ?',"%#{params[:filter]}%")
    elsif params[:id].kind_of?(Fixnum) then
      return Event.find(params[:id])
    else
      return Event.all
      #this obiviously breaks with a user being in multiple groups
      #return current_user.groups.first.events
    end
  end

end
