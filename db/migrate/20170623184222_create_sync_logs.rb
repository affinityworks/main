class CreateSyncLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :sync_logs do |t|
      t.references  :group
      t.references  :origin
      t.string      :synced_resource
      t.jsonb       :data
      t.timestamps
    end
  end
end
