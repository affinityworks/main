class Api::V1::AttendancesController < Api::V1::BaseApiController

  def update
    attendance = Event.find(params[:event_id]).attendances.find(params[:id])
    attendance.update_attributes(attendance_params)
    render json: Api::Resources::AttendanceRepresenter.new(attendance)
  end

  private

  def attendance_params
    params.permit(:attended)
  end
end
