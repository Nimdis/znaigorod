class RobokassaController < ApplicationController
  include ActiveMerchant::Billing::Integrations

  skip_before_filter :verify_authenticity_token

  before_filter :build_notification
  before_filter :find_payment

  def paid
    if @notification.acknowledge
      @payment.approve!
      render :text => @notification.success_response
    else
      head :bad_request
    end
  end

  # Robokassa redirect user to this action if it’s all ok
  def success
    #if !@payment.approved? && @notification.acknowledge
      #@payment.approve!
    #end

    #redirect_to @payment, :notice => I18n.t("notice.robokassa.success")
  end

  # Robokassa redirect user to this action if it’s not
  def fail
    #redirect_to @payment, :notice => I18n.t("notice.robokassa.fail")
  end

  private

  def build_notification
    @notification = Robokassa::Notification.new(request.raw_post, :secret => Settings['robokassa.secret_2'])
  end

  def find_payment
    @payment = Payment.find(@notification.item_id)
  end
end
