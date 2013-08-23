class AddGenderDescriptionActsAsToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :gender, :string
    add_column :visits, :description, :text
    add_column :visits, :acts_as, :string
  end
end
