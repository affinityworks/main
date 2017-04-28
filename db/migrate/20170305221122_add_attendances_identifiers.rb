class AddAttendancesIdentifiers < ActiveRecord::Migration[5.0]
  def up
    change_table :attendances do |t|
      t.text :identifiers, array: true, default: []
    end
  end

  def down
    remove_column :attendances, :identifiers
  end
end
