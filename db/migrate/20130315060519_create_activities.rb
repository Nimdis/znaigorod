class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :title
      t.references :organization
      t.references :user

      t.timestamps
    end
    add_index :activities, :organization_id
    add_index :activities, :user_id
  end
end
