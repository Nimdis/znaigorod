class RemoveReportSendedFromTicket < ActiveRecord::Migration
  def up
    remove_column :tickets, :report_sended
  end

  def down
    add_column :tickets, :report_sended, :boolean, :default => false
  end
end
