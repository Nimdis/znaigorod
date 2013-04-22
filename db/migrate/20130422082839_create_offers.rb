class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.references :coupon
      t.integer :price
      t.integer :number
      t.text :description

      t.timestamps
    end
    add_index :offers, :coupon_id
  end
end
