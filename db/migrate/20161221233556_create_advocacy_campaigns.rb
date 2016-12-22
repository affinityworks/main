class CreateAdvocacyCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :advocacy_campaigns do |t|
      t.string :origin_system
      t.string :name
      t.string :title
      t.string :description
      t.string :summary
      t.string :targets
      t.string :browser_url
      t.string :featured_image_url
      t.integer :total_outreaches
      t.string :type
      t.integer :creator_id, :index
      t.integer :modified_by_id, :index
      t.timestamps
    end
  end
end
