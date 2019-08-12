class AddUrlToPlanPins < ActiveRecord::Migration[5.2]

    def up
      add_column :plan_pins, :url, :string, default:'',  null: false, limit: 4096
    end

    def down
      remove_column :plan_pins, :url, :string
    end

end
