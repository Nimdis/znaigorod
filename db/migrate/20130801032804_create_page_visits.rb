class CreatePageVisits < ActiveRecord::Migration
  def change
    create_table :page_visits do |t|
      t.text :session
      t.references :page_visitable, :polymorphic => true

      t.timestamps
    end
    add_index :page_visits, :page_visitable_id
  end
end
