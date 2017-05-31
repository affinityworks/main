class AddUniqueIndexToGroups < ActiveRecord::Migration[5.0]
  def change
    add_index :groups, :an_api_key, unique: true
  end
end
