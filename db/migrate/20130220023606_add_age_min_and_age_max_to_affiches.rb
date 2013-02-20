class AddAgeMinAndAgeMaxToAffiches < ActiveRecord::Migration
  def change
    add_column :affiches, :age_min, :integer
    add_column :affiches, :age_max, :integer
  end
end
