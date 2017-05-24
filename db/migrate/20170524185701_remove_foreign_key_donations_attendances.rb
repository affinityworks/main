class RemoveForeignKeyDonationsAttendances < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :donations, column: :attendance_id
  end
end
