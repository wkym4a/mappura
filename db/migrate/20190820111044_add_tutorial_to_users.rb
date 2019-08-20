class AddTutorialToUsers < ActiveRecord::Migration[5.2]

    def up
      add_column :users, :tutorial, :boolean, default: true, null: false
    end

    def down
      remove_column :users, :tutorial, :boolean
    end
end
