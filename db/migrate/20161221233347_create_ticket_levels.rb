class CreateTicketLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_levels do |t|
      t.string :title
      t.string :description
      t.float :amount
      t.string :currency
      t.integer :limit
      t.integer :total_tickets
      t.float :total_amount
      t.belongs_to :event
      t.timestamps
    end
  end
end
