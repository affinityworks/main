class CreateTargets < ActiveRecord::Migration[5.0]
  def change
    create_table :targets do |t|
      t.string :title
      t.string :organization
      t.string :given_name
      t.string :family_name
      t.string :ocdid

      t.timestamps
    end

    create_table :outreaches_targets, id: false do |t|
      t.belongs_to :target, index: true
      t.belongs_to :outreach, index: true
    end

  end
end
