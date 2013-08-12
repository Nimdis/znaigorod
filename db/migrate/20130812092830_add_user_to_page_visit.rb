class AddUserToPageVisit < ActiveRecord::Migration
  def change
    add_column :page_visits, :user_id, :integer
    add_index :page_visits, :user_id
  end
end
