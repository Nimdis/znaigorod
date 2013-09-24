class CooperationController < ApplicationController

  %w[benefit statistics our_customers].each do |method|
    define_method(method){}
  end

  def services
    @service_payment = ServicePayment.new
  end

end
