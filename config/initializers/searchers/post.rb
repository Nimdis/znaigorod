HasSearcher.create_searcher :posts do
  models :post

  scope(:order_by_rating)     { order_by(:post_rating, :desc) }
  scope(:order_by_creation)   { order_by(:post_created_at, :desc) }

  property :kind do |search|
    search.with(:kind, search_object.kind) if search_object.kind.try(:present?) unless search_object.kind == 'all'
  end

  scope do
    order_by(:created_at, :desc)
  end
end

HasSearcher.create_searcher :similar_posts do
  models :post
end
