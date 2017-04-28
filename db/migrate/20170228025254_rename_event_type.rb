class RenameEventType < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :type, :osdi_type
  end
end
