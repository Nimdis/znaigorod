class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :ticket_info
      t.integer :number
      t.string :phone

      t.timestamps
    end
    add_index :payments, :ticket_info_id
  end
end
