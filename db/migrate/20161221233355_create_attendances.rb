class CreateAttendances < ActiveRecord::Migration[5.0]
  def change
    create_table :attendances do |t|
      t.string :origin_system
      t.datetime :action_date
      t.string :status
      t.boolean :attended
      t.string :comment
      t.references :person
      t.belongs_to :invited_by, index: true, :class_name => 'Person'
      t.references :event
      t.references :referrer_data
      t.timestamps
    end
  end
end
