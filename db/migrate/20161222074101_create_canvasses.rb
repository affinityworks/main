class CreateCanvasses < ActiveRecord::Migration[5.0]
  def change
    create_table :canvasses do |t|
      t.string :origin_system
      t.datetime :action_date
      t.string :contact_type
      t.string :imput_type
      t.boolean :sucess
      t.string :status_code
      t.references :canvassing_effort
      t.integer :canvasser_id
      t.integer :target_id
      t.timestamps
    end
  end
end
