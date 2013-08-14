class AddSourceToVote < ActiveRecord::Migration
  def change
    add_column :votes, :source, :string
    Vote.update_all(:source => :zg)
  end
end
