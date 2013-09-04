class BetsController < ApplicationController
  inherit_resources

  actions :create

  belongs_to :afisha

  protected

  def build_resource
    super.user = current_user

    @bet
  end
end
