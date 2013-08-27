class RemoveActsAsAndDescriptionFromVisit < ActiveRecord::Migration
  def up
    remove_column :visits, :acts_as
    remove_column :visits, :description
    remove_column :visits, :gender
  end

  def down
    add_column :visits, :acts_as, :string
    add_column :visits, :description, :text
    add_column :visits, :gender, :string
  end
end
