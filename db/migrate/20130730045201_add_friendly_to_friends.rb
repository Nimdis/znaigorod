class AddFriendlyToFriends < ActiveRecord::Migration
  def change
    add_column :friends, :friendly, :boolean, default: false
  end
end
