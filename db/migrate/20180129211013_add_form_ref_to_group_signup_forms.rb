class AddFormRefToGroupSignupForms < ActiveRecord::Migration[5.0]
  def up
    change_table :group_signup_forms do |t|
      t.references :form, foreign_key: true, null: false
      t.remove :page_text, :display_title, :admin_title, :prompt_text
      t.change :group_id, :integer, null: false
      t.rename :person_fields, :inputs
      t.rename :required_fields, :required_inputs
    end
  end

  def down
    change_table :group_signup_forms do |t|
      t.remove :form_id
      t.rename :inputs, :person_fields
      t.rename :required_inputs, :required_fields
      t.change :group_id, :integer, null: true
      t.string :display_title, null: false
      t.string :admin_title, null: false
      t.string :prompt_text, null: false
      t.string :page_text, null: false
    end
  end
end
