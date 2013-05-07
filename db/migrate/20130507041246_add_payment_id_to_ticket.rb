class AddPaymentIdToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :payment_id, :integer
    add_index :tickets, :payment_id
  end
end
