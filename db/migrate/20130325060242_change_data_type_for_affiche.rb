class ChangeDataTypeForAffiche < ActiveRecord::Migration
  def up
    change_table :affiches do |t|
      t.change :age_min, :float
      t.change :age_max, :float
    end
  end

  def down
    change_table :affiches do |t|
      t.change :age_min, :integer
      t.change :age_max, :integer
    end
  end
end
