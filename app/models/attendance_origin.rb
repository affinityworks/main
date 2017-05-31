class AttendanceOrigin < ActiveRecord::Base
  belongs_to :origin
  belongs_to :attendance
end
