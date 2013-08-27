class RemoveVisitedFromVisit < ActiveRecord::Migration
  def up
    Visit.where(visited: false).destroy_all
    remove_column :visits, :visited
  end

  def down
    add_column :visits, :visited, :boolean
  end
end
