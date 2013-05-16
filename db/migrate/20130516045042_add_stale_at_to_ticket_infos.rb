class AddStaleAtToTicketInfos < ActiveRecord::Migration
  def change
    add_column :ticket_infos, :stale_at, :datetime
  end
end
