class AddBalanceToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :balance, :float
  end
end
