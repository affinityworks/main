class CreateScripts < ActiveRecord::Migration[5.0]
  def change
    create_table :scripts do |t|
      t.string :origin_system
      t.string :name
      t.string :title
      t.string :description
      t.string :summary
      t.belongs_to :creator, index: true, :class_name => 'Person'
      t.belongs_to :modified_by, index: true, :class_name => 'Person'
      t.references :canvassing_effort, foreign_key: true

      t.timestamps
    end
  end
end
