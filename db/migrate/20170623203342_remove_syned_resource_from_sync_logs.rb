class RemoveSynedResourceFromSyncLogs < ActiveRecord::Migration[5.0]
  def change
    remove_column :sync_logs, :synced_resource
  end
end
