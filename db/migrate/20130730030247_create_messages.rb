class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :messageable, :polymorphic => true
      t.references :account
      t.integer :producer_id
      t.text :body
      t.string :state
      t.string :kind

      t.timestamps
    end
    add_index :messages, :account_id
    add_index :messages, :messageable_id
  end
end
