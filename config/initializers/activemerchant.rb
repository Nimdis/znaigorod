ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)

ActiveMerchant::Billing::Base.integration_mode = :test #:production
