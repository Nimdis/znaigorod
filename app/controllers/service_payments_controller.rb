class ServicePaymentsController < ApplicationController
  inherit_resources

  actions :new, :create

  def create
    create! do |success, failure|
      success.html do
        integration_module = ActiveMerchant::Billing::Integrations::Robokassa
        integration_helper = integration_module::Helper.new(@service_payment.id, Settings['robokassa.login'], secret: Settings['robokassa.secret_1'], amount: @service_payment.amount)

        redirect_to "#{integration_module.service_url}?#{integration_helper.form_fields.to_query}"
      end
      failure.html { redirect_to cooperation_path }
    end
  end
end
