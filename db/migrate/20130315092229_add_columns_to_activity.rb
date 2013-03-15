class AddColumnsToActivity < ActiveRecord::Migration
  def up
    add_column :activities, :state, :string
    add_column :activities, :activity_at, :datetime
    add_column :activities, :contact_id, :integer

    change_column :activities, :title, :text
  end

  def down
    remove_column :activities, :state
    remove_column :activities, :activity_at
    remove_column :activities, :contact_id

    change_column :activities, :title, :string
  end
end
