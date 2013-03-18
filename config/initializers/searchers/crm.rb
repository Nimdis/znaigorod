HasSearcher.create_searcher(:activities) do
  models :activity

  property :activity do |search|
    if search_object.activity
      search.with(:activity_at).greater_than_or_equal_to(search_object.activity[:from]) if search_object.activity[:from].present?
      search.with(:activity_at).less_than_or_equal_to(search_object.activity[:to])      if search_object.activity[:to].present?
    end
  end

  property :state
  property :user_id
end
