class CreationsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :features,
                :lat, :lon, :radius,
                :page, :per_page

  def initialize(args)
    super(args)

    @page ||= 1
    @per_page = 12
  end

  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :creation, filters: [:categories, :features]
end
