# encoding: utf-8

class CarWashesPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :features,
                :offers,
                :lat, :lon, :radius,
                :page, :per_page

  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :car_wash, filters: [:categories, :features, :offers]

  def selected_kind
    'car_sales_center'
  end

  def categories_links
    CarSalesCentersPresenter.new(categories: ['car_wash']).categories_links
  end


end
