class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.references :affiche
      t.integer :number
      t.float :original_price
      t.float :price

      t.timestamps
    end
    add_index :tickets, :affiche_id
  end
end
