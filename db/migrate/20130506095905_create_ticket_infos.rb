class CreateTicketInfos < ActiveRecord::Migration
  def change
    create_table :ticket_infos do |t|
      t.references :affiche
      t.integer :number
      t.float :original_price
      t.float :price

      t.timestamps
    end
    add_index :ticket_infos, :affiche_id
  end
end
