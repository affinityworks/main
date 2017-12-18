class EventsController < ApplicationController
  before_action :authenticate_person!
  before_action :set_events, only: :index
  before_action :set_event, only: :show
  before_action :authorize_group_access

  protect_from_forgery except: [:create] #TODO: Add the csrf token in react.

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: {
          events: JsonApi::EventsRepresenter.for_collection.new(Event.add_attendance_counts(@events)),
          tags: JsonApi::TagsRepresenter.for_collection.new(Tag.type_event),
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

  def create
    @event = Event.new(events_params)
    @event.groups << current_group
    respond_to do |format|
      if @event.save
        format.json do
          render json: JsonApi::EventRepresenter.new(@event).to_json
        end
      else
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_events
    return [] unless current_group

    #this is a bit clunky and could be cleaned up. --rabble
    return @events = Person.find(params[:member_id]).events.page(params[:page]) if params[:member_id]

    @events = Group.find(params[:group_id]).all_events.includes(:location, :groups)

    @events = @events.tagged_with(params[:tag]) if params[:tag]

    filter = params.fetch(:filter) { nil }

    if filter_by_key(filter, :name)
      @events = Event.joins(:location).where(
        'addresses.venue ilike ? or title ilike ?', "%#{params[:filter][:name]}%","%#{params[:filter][:name]}%"
      )
    end

    start_date = filter_by_key(filter, :start_date)
    end_date = filter_by_key(filter, :end_date)

    if start_date && end_date
      start_date = Date.parse(start_date).beginning_of_day
      end_date =  Date.parse(end_date).end_of_day
      @events = @events.where('start_date BETWEEN ? AND ?', start_date, end_date)
    end

    @events = @events.order("#{sort_param} #{direction_param || 'desc'}").page(params[:page])
  end


  def filter_by_key(filter, key)
    filter&.fetch(key) { nil }
  end

  def events_params
    params.require(:event).permit(:start_date, :title, :description, :origin_system,
                                  :description, location_attributes: [:locality,
                                                                      { address_lines: [] },
                                                                      :postal_code,
                                                                      :venue,
                                                                      :region ])

  end

  def set_event
    @event = Group.find(params[:group_id]).all_events.find(params[:id])
  end

  def sort_param
    return 'start_date' unless params[:sort]
    @sort_param ||= ['title', 'start_date', 'groups.name'].delete(params[:sort])
  end
end
