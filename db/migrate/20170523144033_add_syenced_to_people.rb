class AddSyencedToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :synced, :boolean, default: true
  end
end
