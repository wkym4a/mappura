class AddRouteToPlanPins < ActiveRecord::Migration[5.2]
  def up
    add_column :plan_pins, :route, :integer, default:1,  null: false
  end

  def down
    remove_column :plan_pins, :route, :integer
  end
end
