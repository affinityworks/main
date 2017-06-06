class ChangeGroupsDescriptionTypeToText < ActiveRecord::Migration[5.0]
  def up
    change_column :groups, :description, :text
  end

  def down
    add_column :groups, :temp_description, :string

    Group.find_each do |group|
      temp_description = group.description

      if group.description && group.description.length > 255
        temp_description = group.description[0,254]
      end

      group.update_column(:temp_description, temp_description)
    end

    remove_column :groups, :description

    rename_column :groups, :temp_description, :description
  end
end
