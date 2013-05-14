class SmsClaimsController < ApplicationController
  inherit_resources

  actions :new, :create

  belongs_to :sauna

  def create
    create! { parent.organization }
  end
end
