class AddSyncedAtToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :synced_at, :datetime
  end
end
