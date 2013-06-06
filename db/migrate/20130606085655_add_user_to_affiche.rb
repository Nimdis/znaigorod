class AddUserToAffiche < ActiveRecord::Migration
  def change
    add_column :affiches, :user_id, :integer
    add_index :affiches, :user_id
  end
end
