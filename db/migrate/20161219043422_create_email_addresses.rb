class CreateEmailAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :email_addresses do |t|
      t.boolean :primary
      t.string :address
      t.string :address_type
      t.string :status
      t.belongs_to :person, index: true

      t.timestamps
    end
  end
end
