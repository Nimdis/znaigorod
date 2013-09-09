class AddCodesToBet < ActiveRecord::Migration
  def change
    add_column :bets, :codes, :string
  end
end
