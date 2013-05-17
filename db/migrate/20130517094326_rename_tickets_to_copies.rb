class RenameTicketsToCopies < ActiveRecord::Migration
  def up
    rename_table :tickets, :copies
  end

  def down
    rename_table :copies, :tickets
  end
end
