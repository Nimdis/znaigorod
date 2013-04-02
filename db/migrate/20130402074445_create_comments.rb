class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user
      t.references :commentable, :polymorphic => true
      t.text :body
      t.string :ancestry

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :commentable_id
  end
end
