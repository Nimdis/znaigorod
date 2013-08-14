class AddCategoryAndFeatureToCreation < ActiveRecord::Migration
  def up
    add_column :creations, :category, :text unless column_exists? :creations, :category
    add_column :creations, :feature, :text unless column_exists? :creations, :feature
  end

  def down
    remove_column :creations, :category if column_exists? :creations, :category
    remove_column :creations, :feature if column_exists? :creations, :feature
  end
end
