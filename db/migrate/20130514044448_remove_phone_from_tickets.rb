class RemovePhoneFromTickets < ActiveRecord::Migration
  def up
    remove_column :tickets, :phone
  end

  def down
    add_column :tickets, :phone, :string
  end
end
