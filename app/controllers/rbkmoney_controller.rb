class RbkmoneyController < ApplicationController
  include ActiveMerchant::Billing::Integrations

  skip_before_filter :verify_authenticity_token

  def success
    notification = Robokassa::Notification.new(request.raw_post)

    if notification.acknowledge
      payment = Payment.find(notification.item_id)
      payment.approve!

      render text: notification.success_response
    else
      head :bad_request
    end
  end

  def fail
  end
end
