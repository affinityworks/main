class AllowNullPeopleEmail < ActiveRecord::Migration[5.0]
  def up
    change_column :people, :email, :string, default: nil, null: false
    change_column :people, :encrypted_password, :string, default: nil, null: false

    remove_index :people, :email
    add_index :people, :email
  end

  def down
    change_column :people, :email, :string, default: '', null: false
    change_column :people, :encrypted_password, :string, default: '', null: false

    remove_index :people, :email
    add_index :people, :email, unique: true
  end
end
