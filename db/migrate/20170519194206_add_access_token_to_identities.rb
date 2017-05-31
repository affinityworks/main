class AddAccessTokenToIdentities < ActiveRecord::Migration[5.0]
  def change
    add_column :identities, :access_token, :string
  end
end
