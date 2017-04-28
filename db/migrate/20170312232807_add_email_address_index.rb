class AddEmailAddressIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :email_addresses, [:address, :person_id], unique: true
  end
end
