class CreateForms < ActiveRecord::Migration[5.0]
  def change
    create_table :forms do |t|
      t.string :origin_system
      t.string :name
      t.string :title
      t.string :description
      t.string :summary
      t.string :call_to_action
      t.string :browser_url
      t.string :featured_image_url
      t.integer :total_submissions
      t.references :person, foreign_key: true
      t.integer :creator_id
      t.references :submissions, foreign_key: true

      t.timestamps
    end
  end
end
