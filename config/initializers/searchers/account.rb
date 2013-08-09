HasSearcher.create_searcher :accounts do
  models :account

  property :gender do |search|
    search.with(:gender, search_object.gender) if search_object.gender.try(:present?)
  end

  property :kind do |search|
    search.with(:kind, search_object.kind) if search_object.kind.try(:present?) unless search_object.kind == 'all'
  end

  scope do
    order_by(:rating, :desc)
  end
end
