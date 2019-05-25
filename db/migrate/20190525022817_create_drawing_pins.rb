class CreateDrawingPins < ActiveRecord::Migration[5.2]
  def change
    create_table :drawing_pins do |t|
      t.string :pin_name , null: false, limit: 30
      t.text :pin_article , null: false, limit: 180
      t.string :address , null: false, limit: 255
      t.float :latitude , null: false
      t.float :longitude , null: false
      t.text :image
      t.integer :public_div , null: false, limit: 2 , default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :drawing_pins , :pin_name , unique: true
  end
end
