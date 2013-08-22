class ChangePost < ActiveRecord::Migration
  def change
    add_column :posts, :rating, :string
    add_column :posts, :kind, :text
  end
end
