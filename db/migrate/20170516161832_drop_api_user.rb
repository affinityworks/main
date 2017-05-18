class DropApiUser < ActiveRecord::Migration[5.0]
  def change
    drop_table :api_users
  end
end
