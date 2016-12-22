class CreatePhoneNumbers < ActiveRecord::Migration[5.0]
  def change
    create_table :phone_numbers do |t|
      t.boolean :primary
      t.string :number
      t.string :extension
      t.string :description
      t.string :number_type
      t.string :operator
      t.string :country
      t.boolean :sms_capable
      t.boolean :do_not_call
      t.belongs_to :person, index: true

      t.timestamps
    end
  end
end
