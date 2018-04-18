class AddWhiteboardToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :whiteboard, :text
  end
end
