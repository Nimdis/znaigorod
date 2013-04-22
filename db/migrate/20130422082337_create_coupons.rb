class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :title
      t.text :description
      t.integer :discount
      t.references :organization

      t.timestamps
    end
    add_index :coupons, :organization_id
  end
end
