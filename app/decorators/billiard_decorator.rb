# encoding: utf-8

class BilliardDecorator < SuborganizationDecorator
  decorates :billiard

  def viewable?
    billiard.pool_tables.any?
  end

  def title
    billiard.title? ? billiard.title : "Бильярдный зал"
  end

  def htmlise_features_on_show
    h.content_tag(:ul, features.map {|f| h.content_tag(:li, f)}.join("\n").html_safe, :class => 'features')
  end

  def grouped_decorated_pool_tables
    Hash[pool_tables.group_by(&:kind).map { |k,v| [k, PoolTableDecorator.decorate(v)] }]
  end

  def characteristics_on_list
    characteristics_by_type("features offers")
  end

  def characteristics_on_show
    content = ""
    pool_tables.group_by(&:kind).each do |kind, pool_tables|
      content << "<tr>"
      content << h.content_tag(:td, kind, class: "title", colspan: 2)
      content << "</tr>\n"
      pool_tables.each do |pool_table|
        content << "<tr>"
        content << h.content_tag(:td, h.raw("#{pool_table.size} футов,<br />#{I18n.t("billiard.pool_table", count: pool_table.count)}"))
        content << h.content_tag(:td, prices_table(pool_table))
        content << "</tr>\n"
      end
    end
    h.content_tag(:table, content.html_safe, class: :services_attributes) + characteristics_by_type("features offers")
  end

  def prices_table(pool_table)
    content = ""
    grouped_prices = pool_table.pool_table_prices.group_by(&:day)
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
