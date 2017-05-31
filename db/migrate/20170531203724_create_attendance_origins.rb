class CreateAttendanceOrigins < ActiveRecord::Migration[5.0]
  def change
    create_table :attendance_origins do |t|
      t.references :origin
      t.references :attendance
    end

    Attendance.all.each do |attendance|
      attendance.origins.push(Origin.action_network)
    end
  end
end
