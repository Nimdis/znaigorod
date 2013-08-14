# encoding: utf-8

class CarSalesCentersPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :features,
                :offers,
                :lat, :lon, :radius,
                :page, :per_page

  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :car_sales_center, filters: [:categories, :features, :offers]

  def add_edvanced_categories_links(links)
    links.insert(0, {
        title: I18n.t("organization.kind.car_wash"),
        klass: 'car_wash',
        url: "car_washes_path",
        parameters: {},
        selected: categories_filter[:selected].include?('car_wash'),
        count: HasSearcher.searcher(:car_washes).total
    })
  end
end
