class CreateOutreaches < ActiveRecord::Migration[5.0]
  def change
    create_table :outreaches do |t|
      t.string :origin_system
      t.datetime :action_date
      t.string :type
      t.integer :duration
      t.string :subject
      t.string :message
      t.references :referrer_data, foreign_key: true

      t.timestamps
    end
  end
end
