class MakePaymentsPolymorphic < ActiveRecord::Migration
  def up
    rename_column :payments, :ticket_id, :paymentable_id
    remove_index :payments, :column => :ticket_info_id
    add_column :payments, :paymentable_type, :string
    add_index :payments, :paymentable_id
    add_index :payments, :paymentable_type

    Payment.where(:paymentable_type => nil).update_all :paymentable_type => 'Ticket'
  end

  def down
    rename_column :payments, :paymentable_id, :ticket_id
    remove_index :payments, :column => :paymentable_id
    add_index :payments, :ticket_id
    remove_column :payments, :paymentable_type
  end
end
