class CreateReferrerData < ActiveRecord::Migration[5.0]
  def change
    create_table :referrer_data do |t|
      t.string :source
      t.string :referrer
      t.string :website
      t.string :url

      t.timestamps
    end
  end
end
