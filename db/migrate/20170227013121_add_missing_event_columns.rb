class AddMissingEventColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :share_url, :string
    add_column :events, :total_shares, :integer, default: 0
  end
end
