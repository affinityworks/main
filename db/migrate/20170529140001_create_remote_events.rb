class CreateRemoteEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :remote_events do |t|
      t.string :type
      t.string :name
      t.string :description
      t.string :uid
      t.datetime :start_date
      t.datetime :end_date
      t.integer :event_id
    end
  end
end
