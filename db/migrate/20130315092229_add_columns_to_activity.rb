class AddColumnsToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :state, :string
    add_column :activities, :activity_at, :datetime
    add_column :activities, :user_id, :integer
    add_column :activities, :contact_id, :integer
    change_column :activities, :title, :text
  end
end
