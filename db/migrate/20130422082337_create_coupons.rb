class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :title
      t.text :description
      t.integer :discount

      t.timestamps
    end
  end
end
