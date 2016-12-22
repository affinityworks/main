class CreateSharePages < ActiveRecord::Migration[5.0]
  def change
    create_table :share_pages do |t|
      t.string :origin_system
      t.string :name
      t.string :title
      t.string :description
      t.string :summary
      t.string :browser_url
      t.string :share_url
      t.integer :total_shares
      t.integer :creator_id
      t.integer :modified_by_id
            
      t.timestamps
    end
  end
end
