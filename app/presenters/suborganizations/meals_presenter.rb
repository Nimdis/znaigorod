class MealsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :features,
                :offers,
                :cuisines,
                :lat, :lon, :radius,
                :page, :per_page

  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :meal, filters: [:categories, :features, :offers, :cuisines]
end
