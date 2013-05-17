class DropOffer < ActiveRecord::Migration
  def up
    drop_table :offers
  end

  def down
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
