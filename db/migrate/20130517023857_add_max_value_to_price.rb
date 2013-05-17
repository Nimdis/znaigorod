class AddMaxValueToPrice < ActiveRecord::Migration
  def change
    add_column :prices, :max_value, :integer
  end
end
