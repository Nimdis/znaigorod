class CreateSmsClaim < ActiveRecord::Migration
  def change
    create_table :sms_claims do |t|
      t.string :name
      t.string :phone
      t.text :description
      t.integer :claimed_id
      t.string :claimed_type

      t.timestamps
    end
  end
end
