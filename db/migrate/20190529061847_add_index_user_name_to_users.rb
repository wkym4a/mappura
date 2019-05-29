class AddIndexUserNameToUsers < ActiveRecord::Migration[5.2]
  def up
    add_index :users , :user_name , unique: true
  end

  def down
    remove_index :users , :user_name
  end

end
