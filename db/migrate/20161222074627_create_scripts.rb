class CreateScripts < ActiveRecord::Migration[5.0]
  def change
    create_table :scripts do |t|
      t.string :origin_system
      t.string :name
      t.string :title
      t.string :description
      t.string :summary
      t.integer :person_id
      t.integer :creator_id
      t.references :canvassing_effort, foreign_key: true
      t.index :creator_id
      t.index :person_id

      t.timestamps
    end
  end
end
