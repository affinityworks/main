class AddSyencedToAttendances < ActiveRecord::Migration[5.0]
  def change
    add_column :attendances, :synced, :boolean, default: true
  end
end
