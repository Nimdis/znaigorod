class SearchPresenter

  attr_accessor :params
  attr_reader :kind_filter, :query, :page, :per_page

  def initialize(params)
    @kind_filter = KindFilter.new(params['search_kind'])
    @query = params['q']
    @page = params['page']
    @page ||= 1
    @per_page = 10
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:global, searcher_parameters)
  end

  def searcher_parameters
    @searcher_parameters ||= {}.tap do |searcher_parameters|
      searcher_parameters[:q] = @query
      searcher_parameters[:search_kind] = @kind_filter.search_kind unless @kind_filter.search_all?
    end
  end

  def collection
    @collection ||= searcher.paginate(page: page, per_page: per_page)
  end

  def paginated_collection
    collection.results
  end

  def hits
    HitDecorator.decorate(collection.hits).select { |h| h.result && (!h.organization? || h.raw_suborganization) }
  end

  def hits?
    collection.any?
  end

  def kinds_links
    @kinds_links ||= [].tap { |array|
      @kind_filter.available_kind_values.each do  |kind|
        array << {
          title: I18n.t("search_kinds.#{kind}"),
          klass: kind,
          parameters: {
            q: @query,
            search_kind: kind
          },
          current: kind == @kind_filter.search_kind,
          count: SearchCounter.new(self, kind).count
        }
      end
    }
  end
end

class KindFilter

  attr_accessor :search_kind

  def initialize(search_kind)
    @search_kind = search_kind
    @serch_kind ||= 'all'
  end

  def self.available_kind_values
    %w[all afisha organization post account]
  end

  def available_kind_values
    self.class.available_kind_values
  end

  def search_kind
    available_kind_values.include?(@search_kind) ? @search_kind : 'all'
  end

  available_kind_values.each do |kind|
    define_method "search_#{kind}?" do
      search_kind == kind
    end
  end
end

class SearchCounter
  attr_accessor :presenter, :search_kind

  def initialize(presenter, search_kind)
    @presenter = presenter
    @search_kind = search_kind
    @search_kind = nil if search_kind == 'all'
  end

  def count
    HasSearcher.searcher(:global, presenter.searcher_parameters.merge(:search_kind => search_kind)).total
  end
end
