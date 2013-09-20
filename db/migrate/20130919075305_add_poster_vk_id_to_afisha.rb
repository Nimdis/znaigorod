class AddPosterVkIdToAfisha < ActiveRecord::Migration
  def change
    add_column :afisha, :poster_vk_id, :string
  end
end
