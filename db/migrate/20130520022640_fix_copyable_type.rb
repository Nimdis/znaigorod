class FixCopyableType < ActiveRecord::Migration
  def up
    Copy.where(:copyable_type => 'TicketInfo').update_all(:copyable_type => 'Ticket')
  end

  def down
    Copy.where(:copyable_type => 'Ticket').update_all(:copyable_type => 'TicketInfo')
  end
end
