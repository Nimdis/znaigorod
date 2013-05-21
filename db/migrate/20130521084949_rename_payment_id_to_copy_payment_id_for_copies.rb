class RenamePaymentIdToCopyPaymentIdForCopies < ActiveRecord::Migration
  def up
    rename_column :copies, :payment_id, :copy_payment_id
  end

  def down
    rename_column :copies, :copy_payment_id, :payment_id
  end
end
