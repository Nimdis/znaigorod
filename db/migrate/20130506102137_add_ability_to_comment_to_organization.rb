class AddAbilityToCommentToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :ability_to_comment, :boolean, :default => true
  end
end
