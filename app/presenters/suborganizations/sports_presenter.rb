class SportsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :features,
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

  acts_as_organizations_presenter kind: :sport, filters: [:categories, :features]
end
