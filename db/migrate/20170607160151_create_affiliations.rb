class CreateAffiliations < ActiveRecord::Migration[5.0]
  def change
    create_table :affiliations do |t|
      t.references :group
      t.references :affiliated, references: :group

      t.timestamps
    end
  end
end
