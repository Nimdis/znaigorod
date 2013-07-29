class AddAvatarToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :avatar, :text
  end
end
