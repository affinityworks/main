class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :venue
      t.string :address_lines
      t.string :locality
      t.string :region
      t.string :postal_code
      t.string :country
      t.integer :location_id
      t.string :status
      t.boolean :primary
      t.string :address_type
      t.string :occupation
      t.belongs_to :person, index: true
      t.string  :type
      t.float :longitude
      t.float :latitude
      t.string :location_accuracy

      t.timestamps
    end
  end
end
