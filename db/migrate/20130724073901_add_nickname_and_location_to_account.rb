class AddNicknameAndLocationToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :nickname, :string
    add_column :accounts, :location, :string
  end
end
