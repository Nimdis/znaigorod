# encoding: utf-8

class ActualOrganizations

  def groups
    settings_kinds = []
    today = Time.now.strftime('%A').downcase
    times = Settings["app.actual_organizations.#{today}"]
    times.each do |interval, kinds|
      interval = interval.to_s.split("-").map(&:to_i)
      from, to = interval.first, interval.second
      time_now = Time.now.strftime('%H').to_i
      if time_now >= from && time_now < to
        settings_kinds = kinds
        break
      end
    end
    organization_groups = []
    settings_kinds.each do |kind, options|
      organization_groups << ActualOrganizationGroup.new(:kind => kind, :options => options[:options], :category => options[:category])
    end
    organization_groups
  end

  def total_entertainments
    HasSearcher.searcher(:entertainments).total
  end

  def total_meals
    HasSearcher.searcher(:meals).total
  end

  def total_cultures
    HasSearcher.searcher(:cultures).total
  end

  class ActualOrganizationGroup
    include Rails.application.routes.url_helpers
    include ActiveAttr::MassAssignment
    attr_accessor :kind, :options, :category

    def title
      I18n.t("actual_organizations.#{kind}")
    end

    def url
      url_params = options.dup
      url_category = 'all'
      url_category = url_params.delete(:category) if url_params[:category]
      organizations_path(organization_class: category.pluralize, category: url_category, query: url_params.any? ? Hash[options.map do |key, value| ["#{key.to_s.pluralize}", value] end ].to_a.flatten.join("/") : nil)
    end

    def searcher
      HasSearcher.searcher(:actual_organization, Hash[options.dup.map do |key, value| ["#{category}_#{key}", value] end ])
    end

    def total_count
      searcher.total
    end

    def organizations
      OrganizationDecorator.decorate(searcher.limit(6).results.map(&:organization))
    end
  end
end
