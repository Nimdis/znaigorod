class AddDetailsToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :details, :text
  end
end
