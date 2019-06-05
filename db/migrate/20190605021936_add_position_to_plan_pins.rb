class AddPositionToPlanPins < ActiveRecord::Migration[5.2]
    def up
      add_column :plan_pins, :position, :integer, default:0, null: false
    end

    def down
      remove_column :plan_pins, :position
    end

end
