class ChangeMembershipsRoleTypeToInteger < ActiveRecord::Migration[5.0]
  def up
    change_column_default :memberships, :role, nil
    change_column :memberships, :role, "integer USING (CASE role WHEN 'organizer' THEN '1'::integer ELSE '0'::integer END)", null: false, default: 0
  end

  def down
    change_column_default :memberships, :role, nil
    change_column :memberships, :role, "varchar USING (CASE role WHEN '1' THEN 'organizer'::varchar ELSE 'member'::varchar END)", null: false, default: 'member'
  end
end
