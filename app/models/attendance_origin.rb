class AttendanceOrigin < ActiveRecord::Base
  belongs_to :origin, optional: true
  belongs_to :attendance, optional: true
end
