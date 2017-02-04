class AddPeopleAuthenticationToken < ActiveRecord::Migration[5.0]
  def change
    change_table(:people) do |t|
      t.string :authentication_token, unique: true, index: true
    end
  end
end
