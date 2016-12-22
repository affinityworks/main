class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.string :title
      t.string :description
      t.float :amount
      t.string :currency
      t.string :attended

      t.timestamps
    end
  end
end
