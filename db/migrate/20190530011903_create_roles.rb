class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.integer :div, null: false , unique: true
      t.boolean :admin_flg, null: false , default: false

      t.timestamps
    end
  end
end
