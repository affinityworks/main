class CreatePetitions < ActiveRecord::Migration[5.0]
  def change
    create_table :petitions do |t|
      t.string :origin_system
      t.string :name
      t.string :title
      t.string :description
      t.string :summary
      t.string :browser_url
      t.string :featured_image_url
      t.string :petition_text
      t.integer :total_signatures

      t.timestamps
    end

    create_table :petitions_targets, id: false do |t|
      t.belongs_to :target, index: true
      t.belongs_to :petition, index: true
    end
  end
end
