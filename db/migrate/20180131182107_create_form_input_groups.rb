class CreateFormInputGroups < ActiveRecord::Migration[5.0]
  def change

    create_table :custom_forms do |t|
      t.string :type, null: false
      t.references :form, foreign_key: true
      t.references :group, foreign_key: true
    end

    create_table :form_input_groups do |t|
      t.string :type, null: false
      t.references :custom_form, foreign_key: true
      t.string :inputs, array: true, default: []
      t.string :required, array: true, default: []

      t.timestamps
    end
  end
end
