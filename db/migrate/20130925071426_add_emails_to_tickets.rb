class AddEmailsToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :emails, :text
  end
end
