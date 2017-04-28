class Api::V1::AttendancesController < Api::V1::BaseApiController

  def update
   attendance = attendances.find(params[:id])
   attendance.update_attributes(attendance_params)

   render json: JsonApi::AttendancesRepresenter.new(attendance).to_json
  end

  private

  def attendance_params
    attrs = params.permit(:attended)

    return attrs unless attrs.empty?

    { attended: nil } #NOTE Axios ommits the params if its value is nil.
  end

  def attendances
    Event.find(params[:event_id]).attendances
  end
end
