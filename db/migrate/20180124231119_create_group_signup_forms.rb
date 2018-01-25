class CreateGroupSignupForms < ActiveRecord::Migration[5.0]
  def change
    create_table :group_signup_forms do |t|
      t.references :group, foreign_key: true
      t.string :person_fields, array: true, default: []
      t.string :required_fields, array: true, default: []
      t.string :page_text, null: false
      t.string :button_text, null: false
      t.string :prompt_text, null: false

      t.timestamps
    end
  end
end
