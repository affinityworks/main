class AttendancesController < ApplicationController
  before_action :authenticate_person!
  before_action :find_attendances

  protect_from_forgery except: [:update] #TODO: Add the csrf token in react.

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::AttendancesRepresenter.for_collection.new(@attendances).to_json
      end
      format.pdf do
        render pdf: "attendances",
               template: "attendances/index.pdf.erb",
               locals: { attendances: @attendances },
               margin: { top: 28 },
               header: {
                 html: {
                   template: 'attendances/pdf_header.pdf.erb',
                   locals:   { event: @event, current_group: current_group  }
                 }
               },
               footer: {
                 html: {
                   template: 'attendances/pdf_footer.pdf.erb',
                   locals: { url: "https://affinity.works/events/#{@event.id}/attendance" }
                 }
               }
      end
    end
  end

  def update
   attendance = @attendances.find(params[:id])
   attendance.update_attributes(attendance_params)
   respond_to do |format|
     format.html
     format.json do
       render json: JsonApi::AttendancesRepresenter.new(attendance).to_json
     end
   end
  end

  private

  def attendance_params
    attrs = params.permit(:attended)

    return attrs unless attrs.empty?

    { attended: nil } #NOTE Axios ommits the params if its value is nil.
  end

  def find_event
    @event = current_group.events.find(params[:event_id])
  end

  def find_attendances
    @attendances = find_event.attendances
  end

end
