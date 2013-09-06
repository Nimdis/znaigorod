class My::BetPaymentsController < My::ApplicationController
  actions :new, :create

  belongs_to :afisha, :bet

  defaults :singleton => true

  layout false

  skip_authorization_check

  def create
    create! { |success, failure|
      success.html do
        integration_module = ActiveMerchant::Billing::Integrations::Robokassa
        integration_helper = integration_module::Helper.new(@bet_payment.id, Settings['robokassa.login'], secret: Settings['robokassa.secret_1'], amount: @bet_payment.amount)

        redirect_to "#{integration_module.service_url}?#{integration_helper.form_fields.to_query}" and return
      end

      failure.html { render :new and return }
    }
  end

  protected

  def build_resource
    super
    @bet_payment.user = current_user

    @bet_payment
  end
end
