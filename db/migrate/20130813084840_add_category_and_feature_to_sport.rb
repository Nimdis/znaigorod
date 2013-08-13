class AddCategoryAndFeatureToSport < ActiveRecord::Migration
  def change
    add_column :sports, :category, :text
    add_column :sports, :feature, :text
  end
end
