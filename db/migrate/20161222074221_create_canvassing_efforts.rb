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
      t.belongs_to :creator, index: true, :class_name => 'Person'
      t.belongs_to :modified_by, index: true, :class_name => 'Person'
      t.references :script
      t.timestamps
    end
    create_table :canvassing_efforts_questions, id: false do |t|
      t.belongs_to :question, index: true
      t.belongs_to :canvassing_effort, index: true
    end
  end
end
