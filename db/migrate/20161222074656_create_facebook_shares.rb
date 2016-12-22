class CreateFacebookShares < ActiveRecord::Migration[5.0]
  def change
    create_table :facebook_shares do |t|
      t.references :share_page, foreign_key: true
      t.string :title
      t.string :description
      t.string :image

      t.timestamps
    end
  end
end
