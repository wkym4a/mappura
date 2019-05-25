class CreateWorkboxes < ActiveRecord::Migration[5.2]
  def change
    create_table :workboxes do |t|
      t.references :user, foreign_key: true
      t.string :workbox_name , null: false , limit: 12
      t.boolean :default_box , null: false , default: false

      t.timestamps
    end
  end
end
