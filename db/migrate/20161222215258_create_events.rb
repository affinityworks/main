class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :origin_system
      t.string :name
      t.string :title
      t.string :description
      t.string :summary
      t.string :browser_url
      t.string :type
      t.string :ticket_levels
      t.string :featured_image_url
      t.integer :total_accepted
      t.integer :total_tickets
      t.float :total_amount
      t.string :status
      t.string :instructions
      t.datetime :start_date
      t.datetime :end_date
      t.date :all_day_date
      t.boolean :all_day
      t.integer :capacity
      t.boolean :guests_can_invite_others
      t.string :transparency
      t.string :visibility
      t.integer :creator_id, index: true
      t.integer :organizer_id, index: true
      t.integer :modified_by_id, index: true
      t.references :ticket_levels, foreign_key: true
      t.references :address, foreign_key: true

      t.timestamps
    end
  end
end
