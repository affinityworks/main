class AttendancesController < ApplicationController
  before_action :authenticate_person!
  before_action :find_attendances

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::AttendancesRepresenter.for_collection.new(@attendances).to_json
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
    params.permit(:attended)
  end

  def find_attendances
    @attendances = Event.find(params[:event_id]).attendances
  end

end
