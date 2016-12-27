class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.string :origin_system
      t.datetime :action_date
      t.references :referrer_data
      t.references :person
      t.references :form

      t.timestamps
    end
  end
end
