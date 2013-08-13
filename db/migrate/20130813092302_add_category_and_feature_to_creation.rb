class AddCategoryAndFeatureToCreation < ActiveRecord::Migration
  def change
    add_column :creations, :category, :text
    add_column :creations, :feature, :text
  end
end
