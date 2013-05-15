class RobokassaController < ApplicationController
  include ActiveMerchant::Billing::Integrations

  skip_before_filter :verify_authenticity_token

  def paid
    notification = Robokassa::Notification.new(request.raw_post, secret: Settings['robokassa.secret_2'])

    if notification.acknowledge
      payment = Payment.find(notification.item_id)
      payment.approve

      render text: notification.success_response
    else
      head :bad_request
    end
  end

  def success
    notification = Robokassa::Notification.new(request.raw_post, secret: Settings['robokassa.secret_1'])
    payment = Payment.find(notification.item_id)
    affiche = payment.ticket_info.affiche

    redirect_to affiche, notice: I18n.t('notice.robokassa.success')
  end

  def fail
    notification = Robokassa::Notification.new(request.raw_post)
    payment = Payment.find(notification.item_id)
    affiche = payment.ticket_info.affiche

    payment.cancel

    redirect_to affiche, notice: I18n.t('notice.robokassa.fail')
  end
end
