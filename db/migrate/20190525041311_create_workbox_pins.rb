class CreateWorkboxPins < ActiveRecord::Migration[5.2]
  def change
    create_table :workbox_pins do |t|
      t.references :workbox, foreign_key: true
      t.references :drawing_pin, foreign_key: true

      t.timestamps
    end
  end
end
