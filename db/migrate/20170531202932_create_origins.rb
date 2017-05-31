class CreateOrigins < ActiveRecord::Migration[5.0]
  def change
    create_table :origins do |t|
      t.string :name
    end

    Origin.create(name: 'Action Network')
    Origin.create(name: 'Facebook')
    Origin.create(name: 'Affinity')
  end
end
