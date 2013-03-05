class StatisticsPresenter
  def affiches_with_page_views
    Affiche.unscoped.
      with_showings.
      where('affiches.created_at >= ?', from_date).
      where('yandex_metrika_page_views IS NOT NULL').order('yandex_metrika_page_views DESC').
      limit(10).
      map { |a| AfficheDecorator.new(a) }
  end

  def affiches_with_likes
    Affiche.unscoped.
      with_showings.
      where('affiches.created_at >= ?', from_date).
      where('vkontakte_likes IS NOT NULL').order('vkontakte_likes DESC').
      limit(10).
      map { |a| AfficheDecorator.new(a) }
  end

  def from_date
    1.month.ago
  end

  def organizations_with_page_views
    Organization.unscoped.
      where('yandex_metrika_page_views IS NOT NULL').order('yandex_metrika_page_views DESC').
      limit(10).
      map { |a| OrganizationDecorator.new(a) }
  end

  def organizations_with_likes
    Organization.unscoped.
      where('vkontakte_likes IS NOT NULL').order('vkontakte_likes DESC').
      limit(10).
      map { |a| OrganizationDecorator.new(a) }
  end
end
