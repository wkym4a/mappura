class AddColumnsToPlans < ActiveRecord::Migration[5.2]
  def up
    add_column :plans, :comment, :string, default:'',  null: false, limit: 40
    add_column :plans, :image, :text
  end

  def down
    remove_column :plans, :comment, :string
    remove_column :plans, :image, :text
  end
end
