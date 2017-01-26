class CreateZipcodes < ActiveRecord::Migration[5.0]
  def change
    create_table :zipcodes do |t|
      t.string :zipcode
      t.string :zipcode_type
      t.string :city
      t.string :state
      t.string :location_type
      t.float :lat
      t.float :long
      t.string :location
      t.boolean :decommisioned
      t.boolean :tax_returns_filed
      t.integer :estimated_population
      t.integer :total_wages

      t.timestamps
    end
  end
end
