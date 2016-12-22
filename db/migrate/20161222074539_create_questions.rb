class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :origin_system
      t.string :name
      t.string :title
      t.string :description
      t.string :summary
      t.string :question_type
      t.integer :creator_id
      t.integer :modified_by_id
      t.index :creator_id
      t.index :modified_by_id

      t.timestamps
    end

    create_table :questions_reponses, id: false do |t|
      t.belongs_to :question, index: true
      t.belongs_to :response, index: true
    end
  end
end
