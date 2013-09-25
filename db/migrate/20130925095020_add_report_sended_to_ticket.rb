class AddReportSendedToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :report_sended, :boolean, :default => false
  end
end
