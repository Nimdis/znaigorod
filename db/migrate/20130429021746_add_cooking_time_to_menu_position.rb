class AddCookingTimeToMenuPosition < ActiveRecord::Migration
  def change
    add_column :menu_positions, :cooking_time, :integer
  end
end
