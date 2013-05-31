# encoding: utf-8

class SaunaHallDecorator < ApplicationDecorator
  decorates :sauna_hall

  def title
    sauna_hall.title? ? sauna_hall.title : "Основной зал"
  end

  def price
    min_price = sauna_hall_schedules.minimum(:price)
    max_price = sauna_hall_schedules.maximum(:price)
    h.content_tag :div, humanize_price(min_price, max_price), class: :price
  end

  def schedule
    grouped_schedule = {}
    sauna_hall_schedules.group_by(&:price).each do |price, schedules|
      grouped_schedule[price] = {}
      schedules.each do |schedule|
        daily_schedule = schedule_time(schedule.from, schedule.to)
        grouped_schedule[price][daily_schedule] ||= []
        grouped_schedule[price][daily_schedule] << schedule.day
      end
    end
    orderly_grouped_schedule = {}
    grouped_schedule.each do |price, schedules|
      schedules.each do |schedule_time, days|
        decorated_days = h.content_tag(:span, schedule_day_names(days), class: :days)
        orderly_grouped_schedule[decorated_days] ||= []
        orderly_grouped_schedule[decorated_days] << {schedule_time => price}
      end
    end
    content = ""
    orderly_grouped_schedule.each do |days, schedules|
      timely_content = ""
      schedules.each do |schedule|
        timely_content << h.content_tag(:li, "<span class='time'>#{schedule.keys.first}</span><span class='price'>#{schedule.values.first} руб.</span>".html_safe)
      end
      content << h.content_tag(:li, (days + h.content_tag(:ul, timely_content.html_safe)).html_safe)
    end
    h.content_tag(:div, "<span class='show_more_schedule'>расписание</span>".html_safe, class: "work_schedule") + h.content_tag(:ul, content.html_safe, class: :more_schedule).html_safe
  end

  def htmlise_capacity_on_show
    return "" unless sauna_hall_capacity.present?
    content = h.content_tag(:span, "#{I18n.t('sauna.sauna_hall_capacity.default', count: sauna_hall_capacity.default.to_i)}.\n", class: :capacity_default)
    content << h.content_tag(:span, "#{I18n.t('sauna.sauna_hall_capacity.maximal', count: sauna_hall_capacity.maximal.to_i)}.\n", class: :capacity_maximal)
    content << h.content_tag(:span, "#{I18n.t('sauna.sauna_hall_capacity.extra_guest_cost', count: sauna_hall_capacity.extra_guest_cost.to_i)}", class: :capacity_extra_guest_cost)
  end

  def htmlise_bath_on_show
    return "" unless sauna_hall_bath.present?
    content = "#{I18n.t('sauna.sauna_hall_bath.title')}: "
    baths = []
    sauna_hall_bath.class.accessible_attributes.each do |field|
      baths << attribute_decorate(sauna_hall_bath, field)
    end
    h.content_tag(:div, content + baths.compact.join(", "), class: 'bath')
  end

  def htmlise_pool_on_show
    return "" unless sauna_hall_pool.present?
    pools = []
    pool_attrs = []
    %w[size waterfall contraflow geyser].each do |field|
      pool_attrs << attribute_decorate(sauna_hall_pool, field)
    end
    pool_attrs.delete_if(&:blank?)
    pools << pool_attrs.join(", ") if pool_attrs.any?
    content = pool_attrs.empty? ? '' : "#{I18n.t('sauna.sauna_hall_pool.title')}: "
    %w[jacuzzi bucket].each do |field|
      pools << attribute_decorate(sauna_hall_pool, field)
    end
    h.content_tag(:div, content + pools.compact.join(". "), class: 'pool')
  end

  def htmlise_entertainment_on_show
    return "" unless sauna_hall_entertainment.present?
    entertainment_atts = []
    sauna_hall_entertainment.class.accessible_attributes.each do |field|
      entertainment_atts << attribute_decorate(sauna_hall_entertainment, field)
    end
    %w[pit pylon lounges barbecue].each do |field|
      entertainment_atts << attribute_decorate(sauna_hall_interior, field)
    end
    h.content_tag(:div, entertainment_atts.compact.join(". "), class: 'entertainment')
  end

  def attribute_decorate(model, field)
    return nil unless model.respond_to?(field)
    case value = model.send(field)
    when String
      value
    when Fixnum
      if value < 0
        I18n.t("sauna.#{model.class.name.underscore}.#{field}", count: 0.1)
      else
        I18n.t("sauna.#{model.class.name.underscore}.#{field}", count: value)
      end
    when TrueClass
      I18n.t("sauna.#{model.class.name.underscore}.#{field}.true")
    when FalseClass
      return nil if %w[sauna_hall_bath sauna_hall_pool sauna_hall_interior].include?(model.class.name.underscore)
      I18n.t("sauna.#{model.class.name.underscore}.#{field}.false")
    when NilClass
      nil
    end
  end


  def has_photogallery?
    images.any?
  end

  def images
    gallery_images
  end
end
