class ChangePositionFromPlanPins < ActiveRecord::Migration[5.2]
  def up
    change_column :plan_pins, :position, :integer, null: false
  end

  # 変更前の状態
  def down
    change_column :plan_pins, :position, :integer, default:0, null: false
  end
end
