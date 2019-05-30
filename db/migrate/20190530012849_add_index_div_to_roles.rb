class AddIndexDivToRoles < ActiveRecord::Migration[5.2]
  def up
    add_index :roles , :div , unique: true
  end

  def down
    remove_index :roles , :div
  end

end
