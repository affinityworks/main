class CreatePeople < ActiveRecord::Migration[5.0]

  def change

    # i think this doesn't work yet.
    execute <<-SQL
      CREATE TYPE gender AS ENUM ('Female', 'Male', 'Other');
    SQL
    create_table :people do |t|
      t.string :identifiers, :array
      t.string :family_name
      t.string :given_name
      t.string :additional_name
      t.string :honorific_prefix
      t.string :honorific_sufix
      t.string :gender
      t.string :gender_identity
      t.string :party_identification
      t.string :source
      t.string :ethnicities, :array
      t.string :languages_spoken, :array
      t.date :birthdate
      t.string :employer
      t.text :custom_fields
      #t.datetime :created_date
      #t.datetime :modified_date

      t.timestamps
    end
  end


  # NOTE: It's important to drop table before dropping enum.
  def down
    drop_table :articles

    execute <<-SQL
      DROP TYPE article_status;
    SQL
  end

end
