class AddSocialLikesToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :fb_likes, :integer
    add_column :organizations, :odn_likes, :integer
  end
end
