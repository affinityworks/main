class AttendancesController < ApplicationController
  before_action :authenticate_person!
  before_action :find_attendances

  protect_from_forgery except: [:update] #TODO: Add the csrf token in react.

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: {
          attendances: JsonApi::AttendancesRepresenter.for_collection.new(@attendances),
          total_pages: @attendances.total_pages,
          page: @attendances.current_page
        }.to_json
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

  def create
    attendance = create_attendance
    respond_to do |format|
      format.json do
        render json: attendance
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
    @attendances = find_event.attendances.page(params[:page])
  end

  def create_attendance
    event = Event.find(params[:event_id])

    email = new_attendance_params.delete(:email)
    person = Person.by_email(email).first || Person.create!(new_attendance_params)

    unless person.primary_email_address
      EmailAddress.create(address: email, primary: true, person: person)
    end

    person.memberships.create(group_id: current_group.id)
    person.events.push(event)
  end

  def new_attendance_params
    params.require(:attendance).permit(:email, :family_name, :given_name)
  end
end
