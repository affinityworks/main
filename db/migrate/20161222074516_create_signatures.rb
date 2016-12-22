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
  end
end
