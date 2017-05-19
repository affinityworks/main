class AddOmniauthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :provider, :string
    add_column :people, :uid, :string
  end
end
