class CreateTwitterShares < ActiveRecord::Migration[5.0]
  def change
    create_table :twitter_shares do |t|
      t.references :share_page, foreign_key: true
      t.string :message
      t.integer :total_shares

      t.timestamps
    end
  end
end
