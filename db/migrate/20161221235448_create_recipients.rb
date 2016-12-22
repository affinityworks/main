class CreateRecipients < ActiveRecord::Migration[5.0]
  def change
    create_table :recipients do |t|
      t.string :display_name
      t.string :legal_name
      t.float :amount
      t.references :donation, foreign_key: true

      t.timestamps
    end
  end
end
