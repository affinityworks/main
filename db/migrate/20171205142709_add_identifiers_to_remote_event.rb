class AddIdentifiersToRemoteEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :remote_events, :identifiers, :text, array: true, default: []
  end
end
