class AddInviterAndInvitedFieldsToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :acts_as_inviter, :boolean
    add_column :visits, :acts_as_invited, :boolean
    add_column :visits, :inviter_description, :text
    add_column :visits, :invited_description, :text
    add_column :visits, :invited_gender, :string
    add_column :visits, :inviter_gender, :string
  end
end
