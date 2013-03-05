class SearchPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :params

  def page
    params[:page] || 1
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:global, params)
  end

  def total
    searcher.total
  end

  def collection
    @collection ||= searcher.paginate(page: page, per_page: 10)
  end

  def paginated_collection
    collection.results
  end

  def hits
    HitDecorator.decorate(collection.hits).select { |h| !h.organization? || h.raw_suborganization }
  end

  def hits?
    collection.any?
  end
end
