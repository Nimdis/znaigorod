class RobokassaController < ApplicationController
  include ActiveMerchant::Billing::Integrations

  skip_before_filter :verify_authenticity_token

  def paid
    notification = Robokassa::Notification.new(request.raw_post, secret: Settings['robokassa.secret_2'])

    if notification.acknowledge
      payment = Payment.find(notification.item_id)
      payment.approve!

      render text: notification.success_response
    else
      head :bad_request
    end
  end

  # TODO: надо сделать и проверить
  def success
    notification = Robokassa::Notification.new(request.raw_post, secret: Settings['robokassa.secret_1'])
    payment = Payment.find(notification.item_id)

    if payment.paymentable
      if payment.paymentable.is_a?(Ticket)
        redirect_to tickets_path
      else
        redirect_to coupons_path
      end

      return
    end

    redirect_to cooperation_path
  end

  # TODO: надо сделать и проверить
  def fail
    notification = Robokassa::Notification.new(request.raw_post)
    payment = Payment.find(notification.item_id)
    paymentable = payment.paymentable
    payment.cancel!

    if paymentable
      if paymentable.is_a?(Ticket)
        redirect_to tickets_path
      else
        redirect_to coupons_path
      end

      return
    end

    redirect_to cooperation_path
  end
end
