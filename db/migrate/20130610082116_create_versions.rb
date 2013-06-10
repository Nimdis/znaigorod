class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.text :body
      t.references :versionable, :polymorphic => true
      t.timestamps
    end
    add_index :versions, :versionable_id
  end
end
