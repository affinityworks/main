class CreateGoogleGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :google_groups do |t|
      t.references :group, null: false
      t.string :group_key, null: false
      t.string :email, null: false
      t.string :url, null: false

      t.timestamps
    end
  end
end
