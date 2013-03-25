class CreationsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :features,
                :lat, :lon, :radius,
                :page, :per_page

  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :creation, filters: [:categories, :features]
end
