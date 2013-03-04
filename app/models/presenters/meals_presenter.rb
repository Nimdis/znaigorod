class MealsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :features,
                :offers,
                :cuisines,
                :lat, :lon, :radius,
                :order_by,
                :page, :per_page

  def initialize(args)
    super(args)

    @page ||= 1
    @per_page = 12
    @order_by = %w[nearness popularity].include?(order_by) ? order_by : 'popularity'
  end

  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :meal, filters: [:categories, :features, :offers, :cuisines]
end
