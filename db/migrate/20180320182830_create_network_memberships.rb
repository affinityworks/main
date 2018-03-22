class CreateNetworkMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :network_memberships do |t|
      t.references :network, foreign_key: true
      t.references :group, foreign_key: true
      t.boolean :primary

      t.timestamps
    end
  end
end
