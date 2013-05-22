class Manage::PaymentsController < Manage::ApplicationController
  has_scope :page, :default => 1

  def index
    @payments = Payment.order('id DESC').page(params[:page]).per(20)
  end
end
