class ChangeVisit < ActiveRecord::Migration
  def up
    remove_column :visits, :acts_as_inviter
    remove_column :visits, :acts_as_invited
    remove_column :visits, :inviter_description
    remove_column :visits, :invited_description
    remove_column :visits, :inviter_gender
    remove_column :visits, :invited_gender
  end

  def down
    add_column :visits, :acts_as_inviter, :boolean
    add_column :visits, :acts_as_invited, :boolean
    add_column :visits, :inviter_description, :text
    add_column :visits, :invited_description, :text
    add_column :visits, :inviter_gender, :string
    add_column :visits, :invited_gender, :string
  end
end
