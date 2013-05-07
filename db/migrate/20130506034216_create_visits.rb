class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.references :user
      t.references :visitable, :polymorphic => true
      t.boolean :voted

      t.timestamps
    end
    add_index :visits, :user_id
    add_index :visits, :visitable_id
  end
end
