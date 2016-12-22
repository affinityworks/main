class CreateReminders < ActiveRecord::Migration[5.0]
  def change
    create_table :reminders do |t|
      t.string :method
      t.string :minutes
      t.references :people, foreign_key: true
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
