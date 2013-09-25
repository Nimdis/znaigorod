class AddUndertowToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :undertow, :integer
  end
end
