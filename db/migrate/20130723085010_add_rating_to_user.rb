class AddRatingToUser < ActiveRecord::Migration
  def change
    add_column :users, :rating, :string
  end
end
