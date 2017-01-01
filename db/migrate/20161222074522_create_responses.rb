class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.string :key
      t.string :name
      t.string :title
      t.belongs_to :question
      t.timestamps
    end
  end
end
