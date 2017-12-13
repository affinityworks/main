module HasRemoteEvent
  extend ActiveSupport::Concern

  included do
    after_create :create_remote_events
  end

  private

  def create_remote_events
    AttendanceEvent.create_and_sync(self)
    NoAttendanceEvent.create_and_sync(self)
  end
end
