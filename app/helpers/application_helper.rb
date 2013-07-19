# encoding: utf-8

module ApplicationHelper

  def facet_status(facet, row)
    result = params_have_facet?(facet, row.value) ? 'selected' : 'unselected'
    result << ' inactive' if row.count.zero?

    result
  end

  def image_tag_for(url, width, height, crop = true, orientation = '', alt = '')
    image_tag resized_image_url(url, width, height, crop, orientation), size: "#{width}x#{height}", alt: alt
  end

  def image_image_tag_for(affiche, width, height, options={})
    image_tag resized_image_url(affiche.image_url, width, height, true), :alt => affiche.title, :title => affiche.title
  end

  def resized_link_image(image, resized_width, resized_height)
    if image.thumbnail_url?
      if image.width.present? && !image.width.zero? && image.height.present? && !image.height.zero?
        if (image.height * resized_width / image.width) > resized_height
          link_to(image_tag(image.thumbnail_url, :title => image.description, width: resized_width, height: (image.height * resized_width / image.width)), image.file_url)
        else
          link_to(image_tag(image.thumbnail_url, :title => image.description, width: (image.width * resized_height / image.height), height: resized_height), image.file_url, class: 'wide')
        end
      else
        link_to(image_tag(image.thumbnail_url, :title => image.description), image.file_url)
      end
    else
      link_to(image_tag_for(image.file_url, resized_width, resized_height, true, 'n', image.description), image.file_url)
    end
  end

  def price_for(showing)
    return 'бесплатно' if showing.price_min.zero? && showing.price_max.zero?
    return number_to_currency(showing.price_min, :precision => 0) if showing.price_max.zero?

    "#{showing.price_min} &mdash; #{number_to_currency(showing.price_max, :precision => 0)}".html_safe
  end

  def path_for(item)
    case item.class.superclass.name
    when 'Afisha'
      affiche_path(item)
    when 'Organization'
      organization_path(item)
    end
  end

  def transliterate(string)
    I18n.transliterate(string).downcase.gsub(/[^[:alnum:]]+/,'_')
  end

  def interval_for(showing)
    since_date, since_time = l(showing.starts_at.to_datetime, :format => '%d.%B.%Y %H:%M').split(' ')
    until_date, until_time = l(showing.ends_at.to_datetime, :format => '%d.%B.%Y %H:%M').split(' ') if showing.ends_at

    since_date.gsub!('.', ' ')
    until_date.gsub!('.', ' ') if showing.ends_at

    since_arr = []
    until_arr = []

    since_arr << content_tag(:span, since_date, :class => 'nobr')
    until_arr << content_tag(:span, until_date, :class => 'nobr') if since_date != until_date && !until_date.nil?

    if since_time != '00:00'
      since_arr << ", #{since_time}"
      if until_time != '00:00' && until_time != '23:59' && !until_time.nil?
        if since_time != until_time
          if until_arr.empty?
            until_arr << until_time
          else
            until_arr << ", #{until_time}"
          end
        else
          unless until_arr.empty?
            until_arr << ", #{until_time}"
          end
        end
      end
    else
      if until_time != '00:00' && until_time != '23:59' && !until_time.nil?
        unless until_arr.empty?
          until_arr << ", #{until_time}"
        end
      end
    end

    res = since_arr.join

    unless until_arr.empty?
      res += ' &ndash; '
      res += until_arr.join
    end

    res.html_safe
  end

  def is_active_range?(range_name)
    case range_name
      when 'amount'
        if params['search']['price_greater_than'] == '0' && params['search']['price_less_than'] == '>1500'
          false
        else
          true
        end
      when 'time'
        if params['search']['starts_at_hour_greater_than'] == '0' && params['search']['starts_at_hour_less_than'] == '23'
          false
        else
          true
        end
    end if params['search']
  end

  def is_active_filter?(filter_name)
    return params.has_key?('search') && params['search'][filter_name].try(:any?) ? true : false
  end

  def is_active_variant?(filter, variant)
    if is_active_filter?(filter) == true
      params['search'][filter].include?(variant) ? 'active' : ''
    else
      false
    end
  end

  def form_url_for_resource
    if resource.class.superclass == Afisha || resource_class == Organization
      [:manage, resource]
    elsif Organization.available_suborganization_classes.include?(resource_class)
      send("manage_organization_#{resource_class.model_name.underscore}_path", parent)
    elsif resource.is_a?(GalleryImage) && Organization.available_suborganization_classes.include?(parent_class)
      [:manage, parent, resource]
#    elsif parent.class.superclass == Afisha
#      if (resource_class == GalleryImage || resource_class == GallerySocialImage || resource_class == GalleryFile) && resource.persisted?
#        send("manage_#{parent.class.superclass.model_name.underscore}_#{resource_class.model_name.underscore}_path", parent, resource)
#      else
#        send("manage_#{parent.class.superclass.model_name.underscore}_#{resource_class.model_name.underscore.pluralize}_path", parent)
#      end
    elsif parent.class == Organization
      if (resource_class == GalleryImage || resource_class == GalleryFile) && resource.persisted?
        send("manage_organization_#{resource_class.model_name.underscore}_path", parent, resource)
      else
        send("manage_organization_#{resource_class.model_name.underscore.pluralize}_path", parent)
      end
    elsif parent.class == SaunaHall
      if resource_class == GalleryImage && resource.persisted?
        [:manage, @organization, @sauna_hall, :gallery_image]
      else
        [:manage, @organization, @sauna_hall, :gallery_image]
      end
    elsif parent.class == Post
      if resource_class == PostImage && resource.persisted?
        [:manage, @post, @post_image]
      else
        [:manage, @post, :post_images]
      end
    elsif resource_class == SaunaHall
      if resource.new_record?
        manage_organization_sauna_sauna_halls_path(@organization)
      else
        manage_organization_sauna_sauna_hall_path(@organization, @sauna_hall)
      end
    elsif resource_class == PoolTable
      if resource.new_record?
        manage_organization_billiard_pool_tables_path(@organization)
      else
        manage_organization_billiard_pool_table_path(@organization, @pool_table)
      end
    end
  end

  def resized_image_url(url, width, height, crop, orientation = '')
    if url.match(/\d+\/region\/\d+/)
      image_url, image_id, image_filename = url.match(/(.+)\/files\/(\d+)\/region\/\d+\/\d+\/\d+\/\d+\/(.+)/).to_a[1..-1]
    else
      image_url, image_id, image_width, image_height, image_crop, image_filename =
        url.match(%r{(.*)/files/(\d+)/(?:(\d+)-(\d+)(\!)?/)?(.*)})[1..-1]
    end

    image_crop = crop ? '!' : ''

    "#{image_url}/files/#{image_id}/#{width}-#{height}#{image_crop}#{orientation}/#{image_filename}"
  end

  def stale_at(date)
    if date.hour == 0
      I18n.l(date, :format => '%e %B %Y')
    else
      I18n.l(date, :format => '%e %B %Y года в %H:%M')
    end
  end
end
