class BetsController < ApplicationController
  inherit_resources

  actions :create

  belongs_to :afisha

  custom_actions :resource => [:approve, :cancel]

  layout false

  def create
    create! { |success, failure|
      success.html { render @bet and return }
      failure.html { render :partial => 'form' and return }
    }
  end

  def approve
    approve! {
      @bet.approve!
      render :nothing => true and return
    }
  end

  def cancel
    cancel! {
      @bet.cancel!
      render :nothing => true and return
    }
  end

  protected

  def build_resource
    super.user = current_user

    @bet
  end
end
