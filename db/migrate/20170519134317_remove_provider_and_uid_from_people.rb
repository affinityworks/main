class RemoveProviderAndUidFromPeople < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :provider, :string
    remove_column :people, :uid, :string
  end
end
