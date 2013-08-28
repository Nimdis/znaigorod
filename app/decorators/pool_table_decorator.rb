# encoding: utf-8

class PoolTableDecorator < ApplicationDecorator
  decorates :pool_table

  def ft
    "#{size} ft"
  end

  def price
    min_price = pool_table_prices.minimum(:price)
    max_price = pool_table_prices.maximum(:price)
    humanize_price(min_price, max_price)
  end

  def schedule
    grouped_schedule = {}
    pool_table_prices.group_by(&:price).each do |price, schedules|
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
        decorated_days = schedule_day_names(days)
        orderly_grouped_schedule[decorated_days] ||= []
        orderly_grouped_schedule[decorated_days] << {schedule_time => price}
      end
    end
    content = ""
    orderly_grouped_schedule.each do |days, schedules|
      timely_content = ""
      schedules.each do |schedule|
        timely_content << "<span class='time'>#{schedule.keys.first}</span>, <span class='price'>#{schedule.values.first} руб.</span>; "
      end
      content << h.content_tag(:li, "#{days}: #{timely_content.squish.gsub(/;$/, '')}".html_safe).html_safe
    end
    h.content_tag(:div, "<span class='show_more_schedule'>расписание</span>".html_safe, class: "work_schedule") + h.content_tag(:ul, content.html_safe, class: :more_schedule).html_safe
  end
end
