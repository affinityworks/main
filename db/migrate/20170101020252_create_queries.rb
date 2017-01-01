class CreateQueries < ActiveRecord::Migration[5.0]
  def change
    create_table :queries do |t|
      t.string :origin_system
      t.string :name
      t.string :title
      t.string :description
      t.string :summary
      t.string :browser_url
      t.integer :total_results
      t.integer :creator_id, foreign_key: true
      t.integer :modified_by_id, foreign_key: true

      t.timestamps
    end
  end
end
