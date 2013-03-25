# encoding: utf-8

class SportsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :features,
                :lat, :lon, :radius,
                :page, :per_page

  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :sport, filters: [:categories, :features]
end
