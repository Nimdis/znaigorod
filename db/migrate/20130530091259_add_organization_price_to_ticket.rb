class AddOrganizationPriceToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :organization_price, :float
  end
end
