class AddColumnsToRoles < ActiveRecord::Migration[5.2]
  def up
    add_column :roles, :max_workbox_num, :integer, default:4,  null: false
    add_column :roles, :max_plan_num, :integer, default:24,  null: false
  end

  def down
    remove_column :roles, :max_workbox_num, :integer
    remove_column :roles, :max_plan_num, :integer
  end
end
