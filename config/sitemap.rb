# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = Rails.env.production? ? "http://znaigorod.ru" : "http://localhost:3000"
SitemapGenerator::Sitemap.sitemaps_path = Rails.env.production? ? File.expand_path('../../../../shared/sitemaps/', __FILE__) : ''
SitemapGenerator::Sitemap.create_index = false

SitemapGenerator::Sitemap.create do

  # Списки афиши
  add affiches_path, :changefreq => 'daily', :priority => 0.7, :lastmod => Affiche.unscoped.last.updated_at
  # Фотогалереи
  add photogalleries_path('all'),               :changefreq => 'daily', :priority => 0.5, :lastmod => Affiche.unscoped.last.updated_at
  # Заведения города Томска
  add organizations_path,                       :changefreq => 'daily', :priority => 0.5, :lastmod => Organization.unscoped.last.updated_at

  # Заведения общественного питания в Томске
  add meals_path,              :changefreq => 'daily', :priority => 0.7, :lastmod => Meal.unscoped.last.updated_at

  # Развлекательные заведения в Томске
  add entertainments_path,              :changefreq => 'daily', :priority => 0.7, :lastmod => Entertainment.unscoped.last.updated_at

  # Сауны
  add saunas_path,              :changefreq => 'daily', :priority => 0.7, :lastmod => Sauna.unscoped.last.updated_at

  # Культурные заведения в Томске
  add cultures_path,              :changefreq => 'daily', :priority => 0.7, :lastmod => Culture.unscoped.last.updated_at

  # Спортивные заведения
  add sports_path,              :changefreq => 'daily', :priority => 0.7, :lastmod => Sport.unscoped.last.updated_at

  # Творчество и развитие
  add creations_path,              :changefreq => 'daily', :priority => 0.7, :lastmod => Creation.unscoped.last.updated_at

  # Публикации
  add posts_path,              :changefreq => 'weekly', :priority => 0.7, :lastmod => Post.unscoped.last.updated_at

  # Размещение информации
  add cooperation_path,        :changefreq => 'weekly', :priority => 0.7, :lastmod => DateTime.now - 7.days

  # Мероприятия
  max_rating = Affiche.all.map(&:total_rating).max
  Affiche.find_each do |affiche|
    add send("#{affiche.class.name.downcase}_path", affiche),
      :changefreq => 'weekly',
      :priority => affiche.total_rating/max_rating,
      :lastmod => affiche.updated_at #,
      #:images => [{ :loc => affiche.poster_url, :title => affiche.title }]
  end

  max_rating = Organization.all.map(&:rating).max
  Organization.find_each do |organization|
    if organization.subdomain.blank?
      add organization_path(organization),
        :changefreq => 'weekly',
        :priority => organization.rating > 0 ? organization.rating/max_rating : 0,
        :lastmod => organization.updated_at #,
      #:images => [{ :loc => organization.logotype_url, :title => organization.title }]
    else
      add '',
        :changefreq => 'weekly',
        :priority => organization.rating/max_rating,
        :lastmod => organization.updated_at,
        :host => "http://#{organization.subdomain}.znaigorod.ru"
    end
  end

  Post.find_each do |post|
    add post_path(post),
      :changefreq => 'monthly',
      :priority => 0.6,
      :lastmod => post.updated_at
  end
end
