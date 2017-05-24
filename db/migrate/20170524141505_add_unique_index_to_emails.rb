class AddUniqueIndexToEmails < ActiveRecord::Migration[5.0]
  def change
    add_index :email_addresses, :address, unique: true
  end
end
