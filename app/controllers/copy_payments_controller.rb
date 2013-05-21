class CopyPaymentsController < ApplicationController
  inherit_resources

  actions :new, :create

  belongs_to :ticket, :coupon, :polymorphic => true

  def create
    create! do |success, failure|
      success.html do
        integration_module = ActiveMerchant::Billing::Integrations::Robokassa
        integration_helper = integration_module::Helper.new(@copy_payment.id, Settings['robokassa.login'], secret: Settings['robokassa.secret_1'], amount: @copy_payment.amount)

        redirect_to "#{integration_module.service_url}?#{integration_helper.form_fields.to_query}"
      end
    end
  end

  protected

  def build_resource
    super
    @copy_payment.user = current_user if current_user

    @copy_payment
  end
end
