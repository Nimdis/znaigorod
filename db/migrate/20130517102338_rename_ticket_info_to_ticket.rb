class RenameTicketInfoToTicket < ActiveRecord::Migration
  def up
    rename_table :ticket_infos, :tickets
  end

  def down
    rename_table :tickets, :ticket_infos
  end
end
