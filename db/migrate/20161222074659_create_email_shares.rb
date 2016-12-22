class CreateEmailShares < ActiveRecord::Migration[5.0]
  def change
    create_table :email_shares do |t|
      t.references :share_page, foreign_key: true
      t.string :subject
      t.string :body
      t.integer :total_shares

      t.timestamps
    end
  end
end
