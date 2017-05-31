class AddDefaultStatusToEvents < ActiveRecord::Migration[5.0]
  def change
    change_column :events, :status, :string, default: 'confirmed'
  end
end
