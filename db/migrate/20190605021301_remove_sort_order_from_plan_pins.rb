class RemoveSortOrderFromPlanPins < ActiveRecord::Migration[5.2]
  def up
    remove_column :plan_pins, :sort_order
  end

  def down
    add_column :plan_pins, :sort_order, :integer,  null: false
  end
end
