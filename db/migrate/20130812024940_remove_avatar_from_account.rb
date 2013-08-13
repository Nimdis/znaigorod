class RemoveAvatarFromAccount < ActiveRecord::Migration
  def up
    remove_column :accounts, :avatar
  end

  def down
    add_column :accounts, :avatar, :text
  end
end
