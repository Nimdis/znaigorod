class AddTypeToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :type, :string
    add_index :payments, :type

    Payment.where(:type => nil).update_all :type => 'CopyPayment'
  end
end
