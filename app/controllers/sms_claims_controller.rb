class SmsClaimsController < ApplicationController
  inherit_resources

  actions :new, :create

  Organization.available_suborganization_kinds.each do |kind|
    belongs_to kind, optional: true
  end

  def create
    create! { parent.organization }
  end
end
