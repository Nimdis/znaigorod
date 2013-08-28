# encoding: utf-8

class SaunaDecorator < SuborganizationDecorator
  decorates :sauna

  def viewable?
    sauna_halls.any?
  end

  def title
    sauna.title? ? sauna.title : "Сауна"
  end

  def characteristics_on_list
    characteristics_by_type("features offers")
  end

  def characteristics_on_show

    content = ""
    %w[sauna_accessory sauna_alcohol sauna_broom sauna_oil sauna_massage sauna_child_stuff].each do |model_name|
      content << sauna_model_decorate(model_name)
    end
    content = h.content_tag :div, content.html_safe, class: :sauna_characteristics
    content.html_safe
  end

  def sauna_model_decorate(model_name)
    content = ""
    model = sauna.send(model_name)
    if model.present?
      li = ""
      model.class.accessible_attributes.each do |field|
        li << attribute_decorate(model, field)
      end
      content << h.content_tag(:ul, li.html_safe, class: model_name) if li.present?
    end
    content
  end

  def attribute_decorate(model, field)
    return "" unless model.respond_to?(field)
    case value = model.send(field)
    when String
      h.content_tag :li, [I18n.t("sauna.#{model.class.name.underscore}.#{field}"), value].join(": ")
    when Fixnum
      if value < 0
        h.content_tag :li, I18n.t("sauna.#{model.class.name.underscore}.#{field}", count: 0.1)
      else
        h.content_tag :li, I18n.t("sauna.#{model.class.name.underscore}.#{field}", count: value)
      end
    when TrueClass
      h.content_tag :li, I18n.t("sauna.#{model.class.name.underscore}.#{field}.true")
    when FalseClass
      return "" if %w[sauna_accessory sauna_alcohol sauna_broom sauna_oil sauna_massage sauna_child_stuff sauna_hall_bath sauna_hall_pool sauna_hall_interior].include?(model.class.name.underscore)
      h.content_tag :li, I18n.t("sauna.#{model.class.name.underscore}.#{field}.false")
    when NilClass
      ""
    end
  end

  def decorated_halls
    SaunaHallDecorator.decorate sauna_halls
  end

  def sauna_halls_decorate
    content = ""
    sauna.sauna_halls.each do |sauna_hall|
      content << h.content_tag(:tr, h.content_tag(:td, sauna_hall.title, class: :title))
      content << "<tr><td>"
      content << sauna_hall_model_decorate(sauna_hall, "sauna_hall_capacity")
      content << "</td></tr>"
      content << "<tr><td>"
      content << h.content_tag(:p, I18n.t("sauna.sauna_hall_schedules.title"), class: :offer)
      content << sauna_hall_prices(sauna_hall)
      content << "</td></tr>"
      %w[sauna_hall_bath sauna_hall_pool sauna_hall_entertainment sauna_hall_interior].each do |model_name|
        content << "<tr><td>"
        content << h.content_tag(:p, I18n.t("sauna.#{model_name}.title"), class: :offer)
        content << sauna_hall_model_decorate(sauna_hall, model_name)
        content << "</td></tr>"
      end
    end
    content = h.content_tag(:table, content.html_safe, class: :services_attributes) if content.present?
    content
  end

  def sauna_hall_model_decorate(sauna_hall, model_name)
    content = ""
    model = sauna_hall.send(model_name)
    if model.present?
      li = ""
      model.class.accessible_attributes.each do |field|
        li << attribute_decorate(model, field)
      end
      content << h.content_tag(:ul, li.html_safe) if li.present?
    end
    content
  end

  def sauna_hall_prices(sauna_hall)
    content = ""
    grouped_prices = sauna_hall.sauna_hall_schedules.group_by(&:day)
    organization.schedules.each do |schedule|
      day = h.content_tag(:div, schedule.short_human_day, class: :dow)
      schedule_content = if schedule.holiday?
        h.content_tag(:div, "Выходной".hyphenate, class: :string)
      elsif grouped_prices[schedule.day] == nil
        h.content_tag(:div, "Цена не указана".hyphenate, class: :string)
      else
        intervals_html = ""
        grouped_prices[schedule.day].each do |interval|
          if interval.from == interval.to
            intervals_html << h.content_tag(:div, "Круглосуточно".hyphenate, class: :string)
          else
            intervals_html << h.content_tag(:div, h.raw("#{I18n.l(interval.from, :format => "%H:%M")}&ndash;#{I18n.l(interval.to, :format => "%H:%M")}"), class: [:from_to, :small])
          end
          intervals_html << h.content_tag(:div, "#{interval.price} руб.", class: [:price, :small])
        end
        intervals_html.html_safe
      end
      content << h.content_tag(:li, (day + schedule_content).html_safe, class: I18n.l(Date.today, :format => '%a') == schedule.short_human_day ? 'today' : nil)
    end
    h.content_tag(:ul, content.html_safe, class: :schedule)
  end
end
