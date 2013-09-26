HasSearcher.create_searcher :accounts do
  models :account

  property :gender do |search|
    search.with(:gender, search_object.gender) if search_object.gender.try(:present?)
  end

  property :kind do |search|
    search.with(:kind, search_object.kind) if search_object.kind.try(:present?) unless search_object.kind == 'all'
  end

  property :acts_as do |search|
    search.with(:acts_as, search_object.acts_as) if search_object.acts_as.try(:present?) unless search_object.acts_as == 'all'
  end

  scope(:order_by_activity)     { order_by(:rating, :desc) }
  scope(:order_by_creation)     { order_by(:created_at, :desc) }
  scope(:order_by_friendable)     { order_by(:friendable, :desc) }
end
