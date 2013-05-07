class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.references :ticket_info
      t.string :state
      t.string :phone
      t.string :code

      t.timestamps
    end
    add_index :tickets, :ticket_info_id
  end
end
