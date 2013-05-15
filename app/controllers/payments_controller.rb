class PaymentsController < ApplicationController
  inherit_resources

  actions :new, :create

  belongs_to :ticket_info

  def create
    create! do |success, failure|
      success.html do
        integration_module = ActiveMerchant::Billing::Integrations::Robokassa
        integration_helper = integration_module::Helper.new(@payment.id, Settings['robokassa.login'], secret: Settings['robokassa.secret_1'], amount: @payment.amount)

        redirect_to "#{integration_module.service_url}?#{integration_helper.form_fields.to_query}"
      end
    end
  end

  protected

  def build_resource
    super
    @payment.user = current_user if current_user

    @payment
  end
end
