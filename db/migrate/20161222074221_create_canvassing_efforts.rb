class CreateCanvassingEfforts < ActiveRecord::Migration[5.0]
  def change
    create_table :canvassing_efforts do |t|
      t.string :origin_system
      t.string :name
      t.string :title
      t.string :description
      t.string :summary
      t.datetime :start_time
      t.datetime :end_time
      t.string :type
      t.integer :total_canvasses

      t.timestamps
    end
  end
end
