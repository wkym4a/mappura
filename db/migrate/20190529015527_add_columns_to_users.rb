class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :user_name, :string, default:"", null: false
    add_column :users, :account_name, :string, default:"", null: false
    add_column :users, :email_public_div, :integer, default:9, null: false
    add_column :users, :profile, :text, default:"", null: false
    add_column :users, :public_div, :integer, default:0, null: false
    add_column :users, :pin_public_div_default, :integer, default:0, null: false
  end

  def down
    remove_column :users, :user_name
    remove_column :users, :account_name
    remove_column :users, :email_public_div
    remove_column :users, :profile
    remove_column :users, :public_div
    remove_column :users, :pin_public_div_default
  end
end
