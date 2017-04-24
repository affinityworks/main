class AddAnApiKeyToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :an_api_key, :string
  end
end
