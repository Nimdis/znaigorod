class AddDeviseToUsers < ActiveRecord::Migration
  def up
    change_table(:users) do |t|
      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
    end

    add_column :users, :provider, :string
    add_column :users, :auth_raw_info, :text

    remove_column :users, :email
    remove_column :users, :name
    remove_column :users, :oauth_key
  end

  def down
    remove_column :users, :sign_in_count
    remove_column :users, :current_sign_in_at
    remove_column :users, :last_sign_in_at
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip

    remove_column :users, :provider
    remove_column :users, :auth_raw_info

    add_column :users, :email
    add_column :users, :name
    add_column :users, :oauth_key
  end
end
