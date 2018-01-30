class MoveSubmitTextToForms < ActiveRecord::Migration[5.0]
  def change
    remove_column :group_signup_forms, :button_text, :string
    add_column :forms, :submit_text, :string
  end
end
