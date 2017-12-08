class EventsController < ApplicationController
  before_action :authenticate_person!
  before_action :set_events, only: :index
  before_action :set_event, only: :show
  before_action :authorize_group_access

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

  private

  def set_events
    return [] unless current_group

    #this is a bit clunky and could be cleaned up. --rabble
    return @events = Person.find(params[:member_id]).events.page(params[:page]) if params[:member_id]

    @events = Group.find(params[:group_id]).all_events.includes(:location, :groups)

    @events = @events.tagged_with(params[:tag]) if params[:tag]

    if params[:filter] then
      @events = Event.joins(:location).where(
        'addresses.venue ilike ? or title ilike ?', "%#{params[:filter]}%","%#{params[:filter]}%"
      )
    end

    if sort_param && direction_param
      sort = sort_param == 'group_name' ? 'groups.name' : sort_param
      @events = @events.order("#{sort} #{direction_param}")
    end

    @events = @events.page(params[:page])
  end

  def set_event
    @event = Group.find(params[:group_id]).all_events.find(params[:id])
  end

  def sort_param
    @sort_param ||= ['title', 'start_date', 'group_name'].include?(params[:sort]) && params[:sort] || nil
  end
end
