class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.datetime :action_date
      t.string :value
      t.references :responses, foreign_key: true
      t.references :question, foreign_key: true
      t.references :canvass, foreign_key: true
      t.timestamps
    end
  end
end
