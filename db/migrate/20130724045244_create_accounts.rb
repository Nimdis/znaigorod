class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :first_name
      t.string :last_name
      t.string :patronymic
      t.string :email
      t.string :rating

      t.timestamps
    end
  end
end
