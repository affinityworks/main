class AddTitlesToGroupSignupForms < ActiveRecord::Migration[5.0]
  def change
    add_column :group_signup_forms, :display_title, :string, null: false
    add_column :group_signup_forms, :admin_title, :string, null: false
  end
end
