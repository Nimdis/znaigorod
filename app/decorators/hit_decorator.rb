class HitDecorator < ApplicationDecorator
  decorates 'sunspot/search/hit'

  AFFICHE_FIELDS = %w[tag]
  ORGANIZATION_FIELDS = %w[category cuisine feature offer payment]
  ADDITIONAL_FIELDS = AFFICHE_FIELDS + ORGANIZATION_FIELDS


  def result_decorator
    @decorator ||= if organization?
      OrganizationDecorator.new(result)
    else
      AfficheDecorator.new(result)
    end
  end

  def title_link
    result_decorator.title_link
  end

  def show_url
    result_decorator.show_url
  end

  def image
    result.poster_url.presence
  end

  def image?
    result.poster_url?
  end

  def organization?
    result.is_a?(Organization)
  end

  def image_item
    height = 108
    height = 80 if organization?
    return h.image_tag_for(image, 80, height) if image
    ""
  end

  # FIXME: грязный хак ;(
  def fake_kind
      kind = suborganization.class.name.underscore.gsub(/_decorator/, '')
    %w[billiard sauna].include?(kind) ? 'entertainment' : kind
  end

  def kind_links
    kind = ""
    if organization?
      suborganization.categories.each do |category|
        kind << h.content_tag(:li,
                              h.link_to(category, h.organizations_path(organization_class: fake_kind.pluralize,
                                                                       category: category.mb_chars.downcase)))
      end
    else
      kind << h.content_tag(:li, h.link_to(self.human_kind, h.affiches_path(kind: self.kind.pluralize, period: :all)))
    end
    kind.html_safe
  end

  def human_kind
    I18n.t("activerecord.models.#{kind}")
  end

  def kind
    result.class.name.downcase
  end

  def raw_suborganization
    result.priority_suborganization
  end

  def suborganization_decorator_class
    "#{raw_suborganization.class.name.underscore}_decorator".classify.constantize
  end

  def suborganization
    suborganization_decorator_class.decorate raw_suborganization
  end

  def title
    (highlighted(:title) || result.title.truncated(100)).gilensize
  end

  def excerpt
    (highlighted(:description) || result.description.excerpt).gilensize
  end

  def snipped_links
    links = []
    unless organization?
      %w(photogallery trailer).each do |method|
        links << Link.new(
          title: result_decorator.navigation_title(method),
          url: result_decorator.send("kind_affiche_#{method}_path")
        ) if result_decorator.send("has_#{method}?")
      end
    end
    return "" if links.empty?
    h.content_tag :ul, links.map {|l| h.content_tag :li, l.to_s}.join("\n").html_safe, class: :snipped_links
  end

  def closest
    return "" if organization?
    h.content_tag :div, result_decorator.when_with_price, class: :when_with_price
  end

  def places
    if organization?
      address = highlighted('address')
      link = address ? result_decorator.address_link(address) : result_decorator.address_link
      h.content_tag(:div, h.content_tag(:span, link, class: :address), class: :places)
    else
      result_places = ""
      result_decorator.places.each do |place|
        result_places << place.place
      end
      h.content_tag :div, result_places.html_safe, class: :places
    end
  end

  def splitted_fields(field)
    res = ""
    highlighted(field).to_s.split(",").each do |piece|
      link = ""
      if organization?
        link = "/#{raw_suborganization.class.name.underscore.pluralize}/all/#{field.pluralize}/#{piece.squish.as_text.mb_chars.downcase}"
      else
        link = "/#{kind.pluralize}/all/#{field.pluralize}/#{piece.squish.as_text}"
      end
      res << h.content_tag(:li, h.link_to(piece.squish.html_safe, link))
    end
    res.html_safe
  end

  def to_partial_path
    'hits/hit'
  end

  def highlighted(field)
    (highlights("#{field}_translit") + highlights("#{field}_ru") + highlights(field)).map(&:formatted).map{|phrase| phrase.gsub(/\A[[:punct:][:space:]]+/, '')}.join(' ... ').html_safe.presence
  end

  def truncated(field)
    result.send(field).truncated
  end
end
