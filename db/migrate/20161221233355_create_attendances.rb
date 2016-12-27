class CreateAttendances < ActiveRecord::Migration[5.0]
  def change
    create_table :attendances do |t|
      t.string :origin_system
      t.datetime :action_date
      t.string :status
      t.boolean :attended
      t.string :comment
      t.references :person
      t.integer :invited_by_id
      t.references :event
      t.references :referrer_data
      t.timestamps
    end
  end
end
