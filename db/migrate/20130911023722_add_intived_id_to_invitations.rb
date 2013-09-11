class AddIntivedIdToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :invited_id, :integer
    add_index :invitations, :invited_id
  end
end
