class AddIdentifiers < ActiveRecord::Migration[5.0]
  def change
    # Needs to be change_table; add_column doesn't create correct SQL
    change_table :advocacy_campaigns do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :answers do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :canvasses do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :canvassing_efforts do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :donations do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :events do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :forms do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :fundraising_pages do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :outreaches do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :petitions do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :queries do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :questions do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :scripts do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :script_questions do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :share_pages do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :signatures do |t|
      t.text :identifiers, array: true, default: []
    end

    change_table :submissions do |t|
      t.text :identifiers, array: true, default: []
    end
  end
end
