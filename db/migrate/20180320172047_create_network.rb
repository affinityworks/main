class CreateNetwork < ActiveRecord::Migration[5.0]
  def change
    create_table :networks do |t|
      t.string :name
    end
  end
end
