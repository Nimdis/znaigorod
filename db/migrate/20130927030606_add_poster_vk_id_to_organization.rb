class AddPosterVkIdToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :poster_vk_id, :string
  end
end
