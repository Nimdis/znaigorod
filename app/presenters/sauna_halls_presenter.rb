# encoding: utf-8

class SaunaHallsPresenter
  include ActiveAttr::MassAssignment
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  attr_accessor :capacity,
                :price_min, :price_max,
                :baths, :features, :pool,
                :lat, :lon, :radius,
                :order_by, :direction,
                :params, :page

  alias :pool_features  :pool

  def initialize(args = {})
    super(args)

    self.params = args
    self.params.delete('controller')
    self.params.delete('action')

    self.capacity     = self.capacity.to_i.zero? ? 1 : self.capacity.to_i
    self.price_min    = self.price_min.blank? ?  SaunaHallSchedule.minimum(:price) : self.price_min
    self.price_max    = self.price_max.blank? ?  SaunaHallSchedule.maximum(:price) : self.price_max
    self.radius       = self.radius.blank? ? nil : self.radius

    self.baths    = (self.baths || []).delete_if(&:blank?)
    self.features = (self.features || []).delete_if(&:blank?)
    self.pool     = (self.pool || []).delete_if(&:blank?)

    self.lat    = self.lat.blank? ? nil : self.lat
    self.lon    = self.lon.blank? ? nil : self.lon
    self.radius = self.radius.blank? ? nil : self.radius
    self.page     ||= 1

    self.order_by  = %w[distance popularity price].include?(self.order_by) ? self.order_by : 'popularity'
  end

  def criterion
    order_by == 'price' ? 'price_min' : order_by
  end

  def direction
    criterion == 'popularity' ? 'desc' : 'asc'
  end

  def capacity_hash
    Hashie::Mash.new(
      available: { minimum: SaunaHallCapacity.minimum(:default), maximum: SaunaHallCapacity.maximum(:maximal) },
      selected: capacity
    )
  end

  def price
    Hashie::Mash.new(
      available: { minimum: SaunaHallSchedule.minimum(:price), maximum: SaunaHallSchedule.maximum(:price) },
      selected: { minimum: price_min, maximum: price_max }
    )
  end

  def geo
    Hashie::Mash.new(
      selected: { lat: lat, lon: lon, radius: radius }
    )
  end

  def search(args = {})
    args[:group_by_sauna_id] ||= false
    args[:page]              ||= page
    args[:per_page]          ||= 10

    SaunaHall.search(:include => [
        :organization,
        :address,
        :schedules,
        :sauna_hall_capacity,
        :sauna_hall_pool,
        :sauna_hall_bath,
        :sauna_hall_entertainment,
        :sauna_hall_interior,
        :sauna_hall_schedules,
        :images
    ]) {
      any_of do
        with(:capacity, capacity)
        with(:capacity).greater_than(capacity)
      end

      without(:price_max).less_than(price_min)    if price_min
      without(:price_min).greater_than(price_max) if price_max

      baths.each do |bath|
        with(:baths, bath)
      end

      features.each do |feature|
        with(:features, feature)
      end

      pool_features.each do |feature|
        with(:pool_features, feature)
      end

      if order_by_distance?
        if lat && lon && radius
          order_by_geodist(:location, lat, lon)
        else
          order_by(:popularity, :desc)
        end
      else
        order_by(criterion, direction)
      end

      with(:location).in_radius(lat, lon, radius) if lat && lon && radius

      facet :baths,         sort: :index, zeros: true
      facet :features,      sort: :index, zeros: true
      facet :pool_features, sort: :index, zeros: true

      group :sauna_id if args[:group_by_sauna_id]

      paginate(:page => args[:page], :per_page => args[:per_page])
    }
  end

  def sauna_without_halls_ids
    Sauna.search_ids {
      with(:with_sauna_halls, false)

      with(:location).in_radius(lat, lon, radius) if lat && lon && radius
    }
  end

  def organization_for_saunas_without_halls
    OrganizationDecorator.decorate(Organization.where(:id => Sauna.where(:id => sauna_without_halls_ids).pluck(:organization_id)))
  end

  def search_with_groups
    @search_with_groups ||= search(group_by_sauna_id: true)
  end

  def paginatable_collection
    search_with_groups.group(:sauna_id).groups
  end

  def saunas
    search_with_groups.group(:sauna_id).groups.map(&:value).map { |sauna_id|
      Sauna.find(sauna_id)
    }
  end

  def sauna_halls_search
    @sauna_halls_search ||= search(page: 1, per_page: 500)
  end

  def sauna_hall_ids
    @sauna_hall_ids ||= sauna_halls_search.hits.map(&:primary_key).map(&:to_i)
  end

  def total_count
    search_with_groups.group(:sauna_id).total
  end

  def last_page?
    search_with_groups.group(:sauna_id).groups.total_pages == page.to_i
  end

  def faceted_rows(facet)
    [*search.facet(facet).rows.map(&:value)]
  end

  def capacity_filter_used?
    capacity_hash.selected != 0
  end

  %w[geo price].each do |name|
    define_method "#{name}_filter_used?" do
      self.send(name).selected.values.compact.any?
    end
  end

  %w[baths features pool_features].each do |name|
    define_method "available_#{name}" do
      faceted_rows name
    end

    define_method "selected_#{name}" do
      send("available_#{name}") & send(name)
    end

    define_method "#{name}_filter_used?" do
      send("selected_#{name}").any?
    end
  end

  %w[popularity price].each do |name|
    define_method "order_by_#{name}?" do
      order_by == name
    end

    define_method "#{name}_sort_link" do
      html_options = self.send("order_by_#{name}?") ? { class: "selected #{name}" } : {}

      content_tag :li, link_to(I18n.t("sauna.sort.#{name}"), saunas_path(params.merge(order_by: name)), html_options)
    end
  end

  def order_by_distance?
    order_by == 'distance'
  end

  def distance_sort_link
    html_options = {}
    html_options = { class: 'disabled distance', title: 'Не активно, если не определено ваше местоположение.' } unless geo_filter_used?
    html_options = { class: 'selected distance' } if order_by_distance? && geo_filter_used?

    content_tag :li, link_to( I18n.t('sauna.sort.distance'), saunas_path(params.merge(order_by: 'distance')), html_options)
  end

  def sort_links
    separator = content_tag(:li, content_tag(:span, '&nbsp;', class: 'separator')).html_safe

    [popularity_sort_link, price_sort_link, distance_sort_link].join(separator).html_safe
  end

  def meta_description
    desc = "Подбор сауны в Томске."

    "<meta name='description' content='#{desc.squish}' />".html_safe
  end
end
