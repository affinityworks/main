class AddIndexesToNetworkMemberships < ActiveRecord::Migration[5.0]
  def change
    add_index :network_memberships, [:group_id, :network_id], unique: true
    add_index :network_memberships, [:network_id, :group_id], unique: true
    add_index :network_memberships, :primary
  end
end
