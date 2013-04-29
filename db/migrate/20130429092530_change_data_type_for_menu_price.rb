class ChangeDataTypeForMenuPrice < ActiveRecord::Migration
  def up
    change_table :menu_positions do |t|
      t.change :price, :string
    end
  end

  def down
    change_table :menu_positions do |t|
      t.change :price, :integer
    end
  end
end
