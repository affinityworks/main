class CreateFeatureToggles < ActiveRecord::Migration[5.0]
  def change
    create_table :feature_toggles do |t|
      t.references :group, foreign_key: true
      t.boolean :email_google_group

      t.timestamps
    end
  end
end
