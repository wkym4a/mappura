class AddUrlToDrawingPins < ActiveRecord::Migration[5.2]

    def up
      add_column :drawing_pins, :url, :string, default:'',  null: false, limit: 4096
    end

    def down
      remove_column :drawing_pins, :url, :string
    end

end
