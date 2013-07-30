class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.references :account
      t.references :friendable, polymorphic: true

      t.timestamps

    end
    add_index :friends, :account_id
    add_index :friends, :friendable_id
  end
end
