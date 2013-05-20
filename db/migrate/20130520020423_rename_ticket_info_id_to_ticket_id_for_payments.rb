class RenameTicketInfoIdToTicketIdForPayments < ActiveRecord::Migration
  def change
    rename_column :payments, :ticket_info_id, :ticket_id
  end
end
