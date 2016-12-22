class CreateScriptQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :script_questions do |t|
      t.integer :sequence
      t.references :question, foreign_key: true
      t.references :script, foreign_key: true

      t.timestamps
    end
  end
end
