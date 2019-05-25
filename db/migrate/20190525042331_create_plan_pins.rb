class CreatePlanPins < ActiveRecord::Migration[5.2]
  def change
    create_table :plan_pins do |t|
      t.references :plan, foreign_key: true
      t.references :drawing_pin, foreign_key: true
      t.integer :sort_order, null: false
      t.string :plan_pin_name, null: false, limit: 30
      t.text :plan_pin_article, null: false, limit: 180

      t.timestamps
    end
  end
end
