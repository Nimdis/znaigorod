class AddStateToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :state, :string
  end
end
