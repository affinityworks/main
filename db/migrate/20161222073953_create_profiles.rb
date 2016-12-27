class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.string :provider
      t.belongs_to :person, index: true
      t.string :url
      t.string :handle

      t.timestamps
    end
  end
end
