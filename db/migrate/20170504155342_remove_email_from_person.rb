class RemoveEmailFromPerson < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :email, :string
  end
end
