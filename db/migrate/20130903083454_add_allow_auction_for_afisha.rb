class AddAllowAuctionForAfisha < ActiveRecord::Migration
  def change
    add_column :afisha, :allow_auction, :boolean

    Afisha.update_all :allow_auction => false
  end
end
