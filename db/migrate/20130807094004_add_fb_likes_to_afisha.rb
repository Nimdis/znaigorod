class AddFbLikesToAfisha < ActiveRecord::Migration
  def change
    add_column :afisha, :fb_likes, :integer
  end
end
