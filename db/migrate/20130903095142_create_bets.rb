class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.references :afisha
      t.integer :number
      t.integer :amount
      t.references :user

      t.timestamps
    end
    add_index :bets, :afisha_id
    add_index :bets, :user_id
  end
end
