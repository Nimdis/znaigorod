HasSearcher.create_searcher :accounts do
  models :account

  property :gender do |search|
    search.with(:gender, search_object.gender) if search_object.gender.try(:present?)
  end

  property :kind do |search|
    search.with(:kind, search_object.kind) if search_object.kind.try(:present?)
  end

  property :acts_as do |search|
    search.with(:acts_as, search_object.acts_as) if search_object.acts_as.try(:present?)
  end

  property :inviter_categories do |search|
    search.with(:inviter_categories, search_object.inviter_categories) if search_object.inviter_categories.try(:any?)
  end

  property :invited_categories do |search|
    search.with(:invited_categories, search_object.invited_categories) if search_object.invited_categories.try(:any?)
  end

  property :with_avatar

  scope(:order_by_activity)   { order_by(:rating, :desc) }
  scope(:order_by_creation)   { order_by(:created_at, :desc) }
  scope(:order_by_friendable) { order_by(:friendable, :desc) }
end
