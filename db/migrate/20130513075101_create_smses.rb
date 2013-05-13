class CreateSmses < ActiveRecord::Migration
  def change
    create_table :smses do |t|
      t.string :phone
      t.string :status
      t.integer :smsable_id
      t.string :smsable_type

      t.timestamps
    end
  end
end
