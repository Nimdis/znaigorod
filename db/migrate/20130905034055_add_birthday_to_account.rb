class AddBirthdayToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :birthday, :date
  end
end
