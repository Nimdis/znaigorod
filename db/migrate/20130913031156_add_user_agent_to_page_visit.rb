class AddUserAgentToPageVisit < ActiveRecord::Migration
  def change
    add_column :page_visits, :user_agent, :text
  end
end
