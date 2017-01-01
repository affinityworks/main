class CreateSignatures < ActiveRecord::Migration[5.0]
  def change
    create_table :signatures do |t|
      t.string :origin_system
      t.datetime :action_date
      t.string :comments
      t.references :referrer_data, foreign_key: true
      t.references :petition, foreign_key: true
      t.references :person, foreign_key: true

      t.timestamps
    end

    create_table :petitions_signatures, id: false do |t|
      t.belongs_to :signature, index: true
      t.belongs_to :petition, index: true
    end
  end
end
