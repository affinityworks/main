class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :origin_system
      t.string :name
      t.string :title
      t.string :description
      t.string :summary
      t.string :question_type
      t.belongs_to :creator, index: true, :class_name => 'Person'
      t.belongs_to :modified_by, index: true, :class_name => 'Person'

      t.timestamps
    end

    create_table :questions_reponses, id: false do |t|
      t.belongs_to :question, index: true
      t.belongs_to :response, index: true
    end
  end
end
