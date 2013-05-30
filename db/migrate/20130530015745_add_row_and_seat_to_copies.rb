class AddRowAndSeatToCopies < ActiveRecord::Migration
  def change
    add_column :copies, :row, :integer
    add_column :copies, :seat, :integer
  end
end
