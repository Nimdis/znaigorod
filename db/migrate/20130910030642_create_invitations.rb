class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :inviteable, :polymorphic => true
      t.references :account
      t.string :kind
      t.string :category
      t.text :description
      t.string :gender

      t.timestamps
    end
    add_index :invitations, :inviteable_id
  end
end
