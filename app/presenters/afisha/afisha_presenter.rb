# encoding: utf-8

require 'afisha_presenter_filter'

class AfishaPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :period, :on,
                :price_min, :price_max,
                :age_min, :age_max,
                :time_from, :time_to,
                :organization_ids,
                :tags,
                :lat, :lon, :radius,
                :order_by,
                :page, :per_page,
                :view,
                :hide_categories,
                :has_tickets

  def initialize(args)
    super(args)
    self.categories ||= []

    @page     ||= 1
    @per_page   = 18
    @view       = 'posters'

    initialize_filters
  end

  def initialize_filters
    @categories_filter    ||= CategoriesFilter.new(categories, hide_categories)
    @period_filter        ||= PeriodFilter.new(period, on)
    @price_filter         ||= PriceFilter.new(price_min, price_max)
    @age_filter           ||= AgeFilter.new(age_min, age_max)
    @time_filter          ||= TimeFilter.new(time_from, time_to)
    @organizations_filter ||= OrganizationsFilter.new(organization_ids)
    @tags_filter          ||= TagsFilter.new(tags, @categories_filter.only_category)
    @geo_filter           ||= GeoFilter.new(lat, lon, radius)
    @sorting_filter       ||= SortingFilter.new(order_by, @geo_filter)
  end
  attr_reader :age_filter, :categories_filter, :organizations_filter, :period_filter,
    :price_filter, :tags_filter, :time_filter, :geo_filter, :sorting_filter, :has_tickets

  def url
    @url ||= "#{(categories_filter.selected.first.try(:pluralize) || 'afisha')}_index_path"
  end

  def kind
    @kind ||= categories_filter.selected.first.try(:pluralize) || 'afisha'
  end

  def collection
    if @collection
      return @collection
    else
      @collection = searcher.group(:afisha_id_str).groups
      #@collection = Afisha.published.includes(:showings)
      #@collection = @period_filter.scopes(@collection)
      #@collection = @categories_filter.scopes(@collection)
    end
  end

  def decorated_collection
    collection.map do |group|
      afisha = Afisha.find(group.value)
      showings = group.hits.map(&:result)

      AfishaDecorator.new(afisha, ShowingDecorator.decorate(showings))
    end
    #collection.page(page).per(per_page).map {|afisha| AfishaDecorator.new(afisha, afisha.showings)}
  end

  def paginated_collection
    searcher.group(:afisha_id_str).groups
    #collection.page(page).per(per_page)
  end

  def total_count
    searcher.group(:afisha_id_str).total
  end

  def view_list?
    view == 'list'
  end

  def partial
    "afishas/afisha_#{view}"
  end

  def categories_links
    @categories_links ||= [].tap { |array|
      array << {
        title: I18n.t('enumerize.afisha.kind.all'),
        klass: 'afisha',
        url: 'afisha_index_path',
        parameters: {
          period: @period_filter.all? ? nil : @period_filter.period,
          on: @period_filter.date,
          order_by: @sorting_filter.order_by,
          has_tickets: has_tickets
        },
        current: kind == 'afisha',
        count: AfishaCounter.new(presenter: self).count
      }
      Afisha.kind.values.each do |kind|
        array << {
          title: "#{kind.text}",
          klass: kind.pluralize,
          url: "#{kind.pluralize}_index_path",
          parameters: {
            period: period_filter.all? ? nil : period_filter.period,
            on: @period_filter.date,
            order_by: @sorting_filter.order_by,
            has_tickets: has_tickets
          },
          current: categories.include?(kind),
          count: AfishaCounter.new(presenter: self, categories: [kind]).count
        }
      end
    }
  end

  def periods_links
    @periods_links ||= [].tap { |array|
      @period_filter.available_period_values.each do |period_value|
        array << {
          title: (@period_filter.daily? && period_value == 'daily') ? I18n.l(@period_filter.date, format: '%d %B').gsub(/^0/, '') : I18n.t("afisha_periods.#{period_value}"),
          url: url,
          class: period_value,
          parameters: {
            :period => period_value,
            :order_by => @sorting_filter.order_by,
            has_tickets: has_tickets
          },
          selected: period_value == @period_filter.period
        }
      end
      array.insert(0, {
          title: 'Все',
          url: url,
          class: :all,
          parameters: {
            :period => nil,
            :order_by => @sorting_filter.order_by,
            has_tickets: has_tickets
          },
          selected: @period_filter.all?

      })
    }
  end

  def sortings_links
    @sortings_links ||= [].tap { |array|
      @sorting_filter.available_sortings_values.each do |sorting_value|
        array << {
          title: I18n.t("afisha.sort.#{sorting_value}"),
          url: url,
          parameters: {
            :period => @period_filter.period,
            on: @period_filter.date,
            :order_by => sorting_value,
            has_tickets: has_tickets
          },
          selected: @sorting_filter.order_by == sorting_value
        }
      end
    }
  end

  def keywords
    [].tap { |keywords|
      keywords.concat(categories_filter.human_names) if keywords.empty?
    }.join(', ')
  end

  def page_title
    title = I18n.t("meta.#{kind}.title")
    title += " сегодня" if period_filter.period == 'today'
    title += " на этой неделе" if period_filter.period == 'week'
    title += " на выходных" if period_filter.period == 'weekend'
    title += "за #{I18n.l(period_filter.date, format: "%d %B")}" if period_filter.date?
    title
  end

  def meta_description
    I18n.t("meta.#{kind}.description", default: I18n.t('meta.default.description'))
  end

  def meta_keywords
    I18n.t("meta.#{kind}.keywords", default: I18n.t('meta.default.description'))
  end

  def searcher_params(categories = [])
    @searcher_params ||= {}.tap do |params|
      params[:age_max]          = age_filter.maximum         if age_filter.maximum.present?
      params[:age_min]          = age_filter.minimum         if age_filter.minimum.present?
      params[:afisha_state]     = 'published'
      params[:categories]       = categories_filter.selected if categories_filter.selected.any?
      params[:organization_ids] = organizations_filter.ids   if organizations_filter.ids.any?
      params[:price_max]        = price_filter.maximum       if price_filter.maximum.present?
      params[:price_min]        = price_filter.minimum       if price_filter.minimum.present?
      params[:starts_on]        = period_filter.date         if period_filter.date?
      params[:tags]             = tags_filter.selected       if tags_filter.selected.any?
      params[:from]             = time_filter.from           if time_filter.from.present?
      params[:to]               = time_filter.to             if time_filter.to.present?
      params[:has_tickets]      = true                       if has_tickets

      params[:location] = Hashie::Mash.new(lat: geo_filter.lat, lon: geo_filter.lon, radius: geo_filter.radius) if geo_filter.used?
    end
  end

  private

  def searcher
    @searcher ||= HasSearcher.searcher(:showings, searcher_params).tap { |s|
      s.paginate(page: page, per_page: per_page)
      s.groups
      s.send("order_by_#{sorting_filter.order_by}")

      unless period_filter.date?
        case period_filter.period
        when 'all'
          s.actual
        when 'today'
          s.today.actual
        when 'week'
          s.week.actual
        when 'weekend'
          s.weekend.actual
        end
      end
    }
  end
end
