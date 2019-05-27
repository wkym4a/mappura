class RemoveIndexPinNameToDrawingPins < ActiveRecord::Migration[5.2]
  def up
    remove_index :drawing_pins , :pin_name
  end

  def down
    add_index :drawing_pins , :pin_name , unique: true
  end
end
