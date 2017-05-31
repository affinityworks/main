class AttendancesController < ApplicationController
  before_action :authenticate_person!
  before_action :find_attendances
  before_action :authorize_group_access

  protect_from_forgery except: [:update, :create] #TODO: Add the csrf token in react.

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
    attendance = new_attendance
    respond_to do |format|
      format.json do
        if attendance.save
          render json: JsonApi::AttendancesRepresenter.new(attendance).to_json
        else
          render json: attendee.errors.full_messages, status: 422
        end
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
    @attendances = find_event.attendances.joins(:person).includes(
      :email_addresses, :phone_numbers, :personal_addresses
    ).order('LOWER("people"."given_name") asc').page(params[:page])
  end

  def new_attendance
    event = Event.find(params[:event_id])

    person = Person.by_email(new_attendance_params['primary_email_address']).first ||
              Person.create(new_attendance_params.merge(synced: false))

    person.memberships.find_or_create_by(group_id: current_group.id)
    attendance = person.attendances.find_or_initialize_by(event_id: event.id) do |attendance|
      attendance.invited_by_id ||= current_user.id
      attendance.status ||= 'tentative'
      attendance.synced = false
    end

    attendance
  end

  def new_attendance_params
    params.require(:attendance).permit(
      :primary_email_address, :family_name, :given_name, :primary_phone_number,
      primary_personal_address: [:locality, { address_lines: [] }, :postal_code]
    )
  end
end
