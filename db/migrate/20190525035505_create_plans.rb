class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.references :user, foreign_key: true
      t.string :plan_name , null: false , limit: 20
      t.boolean :default_plan , null: false , default: false
      t.integer :public_div , null: false, limit: 2 , default: 0
      t.string :password_digest
      t.references :workbox, foreign_key: true

      t.timestamps
    end
  end
end
