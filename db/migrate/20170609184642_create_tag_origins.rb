class CreateTagOrigins < ActiveRecord::Migration[5.0]
  def change
    create_table :tag_origins do |t|
      t.references :origin
      t.references :tag
      t.string :uid
    end
  end
end
