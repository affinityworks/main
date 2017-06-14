class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.references  :notable, polymorphic: true, index: true
      t.references  :author, references: :person
      t.text        :text
    end
  end
end
