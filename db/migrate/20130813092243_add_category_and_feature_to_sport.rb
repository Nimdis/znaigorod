class AddCategoryAndFeatureToSport < ActiveRecord::Migration
  def up
    add_column :sports, :category, :text unless column_exists? :sports, :category
    add_column :sports, :feature, :text unless column_exists? :sports, :feature
  end

  def down
    remove_column :sports, :category if column_exists? :sports, :category
    remove_column :sports, :feature if column_exists? :sports, :feature
  end
end
