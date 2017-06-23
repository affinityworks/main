class DashboardController < ApplicationController
  before_action :authorize_group_access

  def show
    @group = Group.find(params[:group_id])

    respond_to do |format|
      format.html
      format.json do
        render json: {
          sync: @group.sync_logs.last,
          events: Event.activity_feed(@group),
          attendances: Attendance.activity_feed(@group),
          people: Person.activity_feed(@group)
        }.to_json
      end
    end
  end
end
