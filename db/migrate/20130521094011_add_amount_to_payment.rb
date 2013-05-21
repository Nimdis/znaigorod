class AddAmountToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :amount, :float

    CopyPayment.reset_column_information

    CopyPayment.where(:amount => nil).each { |payment| payment.update_attribute :amount, payment.number * payment.paymentable.price }
  end
end
