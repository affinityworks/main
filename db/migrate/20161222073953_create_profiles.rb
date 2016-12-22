class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.string :provider
      t.integer :person_id
      t.string :url
      t.string :handle

      t.timestamps
    end
  end
end
