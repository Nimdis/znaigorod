# encoding: utf-8

class ApplicationDecorator < Draper::Base

  def resized_image_url(url, width, height, crop = true)
    return "" if url.blank?
    image_url, image_id, image_width, image_height, image_crop, image_filename =
      url.match(%r{(.*)/files/(\d+)/(?:(\d+)-(\d+)(\!)?/)?(.*)})[1..-1]

    image_crop = crop ? '!n' : ''

    "#{image_url}/files/#{image_id}/#{width}-#{height}#{image_crop}/#{image_filename}"
  end

  def image_tag(url, width, height, title, crop = true)
    options = {size: "#{width}x#{height}"}
    options.merge!(title: title, alt: title) if title.present?
    h.image_tag(h.resized_image_url(url, width, height, crop), options)
  end

  def humanize_price(price_min, price_max)
    return "стоимость не указана".hyphenate if price_min.nil?
    return "бесплатно".hyphenate if price_min == 0 && (price_max.nil? || price_max == 0)
    return "#{price_min} руб.".hyphenate if price_min > 0 && price_max == price_min
    return "от #{price_min} руб.".hyphenate if price_min > 0 && (price_max.nil? || price_max == 0)
    return "#{price_min} &ndash; #{price_max} руб.".hyphenate.html_safe if price_min > 0 && price_max > 0
    return "от 0 до #{price_max} руб.".hyphenate.html_safe if price_min == 0 && price_max > 0
  end

  def open_closed(from, to)
    return "closed" if from.nil? || to.nil?
    now = Time.zone.now
    time = Time.utc(2000, "jan", 1, now.hour, now.min)
    to = to + 1.day if to.hour < 12
    if time.between?(from, to)
      return "opened"
    else
      return "closed"
    end
  end

  def schedule_day_names(days)
    result = ""
    sequence = days
    begin
      sequence = (days.first..days.last).to_a
      eql_index = 0
      sequence.each_with_index do |day, index|
        break unless days[0..index].eql?(sequence[0..index])
        eql_index = index
      end
      out_days = days[0..eql_index]
      days = days[eql_index+1..days.size-1]
      result << "#{short_wday_name(out_days.first)}" if out_days.one?
      result << out_days.map {|d| short_wday_name(d)}.join(", ") if out_days.size == 2
      result << "#{short_wday_name(out_days.first)}-#{short_wday_name(out_days.last)}" if out_days.size > 2
      result << ", " unless days.empty?
    end while days.any?
    result.squish
  end

  def short_wday_name(day)
    Schedule.days_for_select(:short)[day-1].first
  end

  def schedule_time(from, to)
    return "выходной" if from.nil? || to.nil?
    return "круглосуточно" if from == to
    "с #{I18n.l(from, :format => "%H:%M")} до #{I18n.l(to, :format => "%H:%M")}"
  end

  def human_age(age)
    "#{age} лет"
  end


end
