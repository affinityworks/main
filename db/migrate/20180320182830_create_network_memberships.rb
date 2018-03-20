class CreateNetworkMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :network_memberships do |t|
      t.references :network, foregin_key: true
      t.references :group, foregin_key: true
      t.boolean :primary

      t.timestamps
    end
  end
end
