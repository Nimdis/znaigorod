class AddPaymentSystemToTicketsAndCoupons < ActiveRecord::Migration
  def change
    add_column :tickets, :payment_system, :string
    add_column :coupons, :payment_system, :string

    Ticket.update_all :payment_system => :robokassa
    Coupon.update_all :payment_system => :robokassa
  end
end
