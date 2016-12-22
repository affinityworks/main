class CreateFundraisingPages < ActiveRecord::Migration[5.0]
  def change
    create_table :fundraising_pages do |t|
      t.string :origin_system
      t.string :name
      t.string :title
      t.string :description
      t.string :summary
      t.string :browser_url
      t.string :featured_image_url
      t.integer :total_donations
      t.float :total_amount
      t.string :currency
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
