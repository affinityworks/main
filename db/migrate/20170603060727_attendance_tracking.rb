class AttendanceTracking < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :attendances_count, :integer, default: 0
  end
end
