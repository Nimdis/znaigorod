class AddStateToBets < ActiveRecord::Migration
  def change
    add_column :bets, :state, :string
  end
end
