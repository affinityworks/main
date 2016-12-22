class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.string :method
      t.string :reference_number
      t.boolean :authorization_stored
      t.references :donation, foreign_key: true

      t.timestamps
    end
  end
end
