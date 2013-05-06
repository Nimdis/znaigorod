class RobokassaController < ApplicationController
  #include ActiveMerchant::Billing::Integrations

  skip_before_filter :verify_authenticity_token # skip before filter if you chosen POST request for callbacks

  before_filter :create_notification
  #before_filter :find_payment

  # Robokassa call this action after transaction
  def paid
    if @notification.acknowledge # check if it’s genuine Robokassa request
      #@payment.approve! # project-specific code
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

  def create_notification
    @notification = ActiveMerchant::Billing::Integrations::Robokassa::Notification.new(request.raw_post, :secret => Settings['robokassa.secret_2'])
  end

  #def find_payment
    #@payment = Payment.find(@notification.item_id)
  #end
end
