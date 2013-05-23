class AddPublishedToAffiche < ActiveRecord::Migration
  def change
    add_column :affiches, :state, :string

    Affiche.where(:state => nil).update_all :state => :published
  end
end
