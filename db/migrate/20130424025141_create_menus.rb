class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.references :meal
      t.string :category
      t.text :description

      t.timestamps
    end
    add_index :menus, :meal_id
  end
end
