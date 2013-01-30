class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :oauth_key
      t.integer :roles_mask

      t.timestamps
    end

    add_index :users, :oauth_key, :unique => true
  end
end
