class CreateMenuPositions < ActiveRecord::Migration
  def change
    create_table :menu_positions do |t|
      t.references :menu
      t.string :position
      t.string :title
      t.text :description
      t.integer :price
      t.string :count

      t.timestamps
    end
    add_index :menu_positions, :menu_id
  end
end
