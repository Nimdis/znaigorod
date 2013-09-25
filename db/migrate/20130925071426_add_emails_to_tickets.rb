class AddEmailsToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :email_addressess, :text
  end
end
