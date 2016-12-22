class CreateDonations < ActiveRecord::Migration[5.0]
  def change
    create_table :donations do |t|
      t.string :origin_system
      t.datetime :action_date
      t.float :amount
      t.float :credited_amount
      t.datetime :created_date
      t.string :currency
      t.string :subscription_instance
      t.boolean :voided
      t.datetime :voided_date
      t.string :url
      t.references :referrer_data, foreign_key: true
      t.references :person, foreign_key: true
      t.references :fundraising_page, foreign_key: true
      t.references :attendance, foreign_key: true

      t.timestamps
    end
  end
end
