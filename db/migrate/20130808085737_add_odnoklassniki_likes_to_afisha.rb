class AddOdnoklassnikiLikesToAfisha < ActiveRecord::Migration
  def change
    add_column :afisha, :odn_likes, :integer
  end
end
