class CopyPaymentsController < ApplicationController
  inherit_resources

  actions :new, :create

  belongs_to :ticket, :coupon, :polymorphic => true

  def create
    create! do |success, failure|
      success.html { redirect_to @copy_payment.service_url and return }
    end
  end

  protected

  def build_resource
    super
    @copy_payment.user = current_user if current_user

    @copy_payment
  end
end
