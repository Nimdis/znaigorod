class CulturesPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :features,
                :offers,
                :lat, :lon, :radius,
                :page, :per_page

  def initialize(args)
    super(args)

    @page ||= 1
    @per_page = 12
  end

  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :culture, filters: [:categories, :features, :offers]
end
