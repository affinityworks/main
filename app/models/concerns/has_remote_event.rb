module HasRemoteEvent
  extend ActiveSupport::Concern

  included do
    after_create :create_remote_events, if: :origin_system_is_action_network?
  end

  private

  def create_remote_events
    AttendanceEvent.replicate_and_export(self)
    NoAttendanceEvent.replicate_and_export(self)
  end
end
