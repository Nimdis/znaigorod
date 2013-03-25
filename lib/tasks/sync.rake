# encoding: utf-8

require 'open-uri'
require 'nokogiri'
require 'timecop'

require 'rack'
require 'airbrake'

class MovieSyncer
  attr_accessor :movies, :place

  def initialize(options)
    self.place = options.delete(:place)
    self.movies = options.delete(:movies)
  end

  def self.now
    @now ||= Time.zone.now.change(:sec => 0)
  end

  def self.finded_movies
    @finded_movies ||= []
  end

  def sync
    puts "#{place}: импорт сеансов"
    now = Time.zone.now.change(:sec => 0)
    bar = ProgressBar.new(movies.values.map(&:count).sum)
    movies.each do |title, seances|
      next unless title.squish
      if (movie = find_movie_by(title.squish)) && (cinematheatre = find_similar_cinematheatre_by(place.squish))
        MovieSyncer.finded_movies << movie
        showings = Showing.where(:id => Showing.search{with(:affiche_id, movie.id); fulltext(place){fields(:place, :organization_title)}; paginate(:per_page => '100000')}.results.map(&:id))

        seances.each do |seance|
          seance.each do |k,v| v.squish! if v.is_a?(String) end

          Timecop.freeze(MovieSyncer.now) do
            if showing = showings.find_by_hall_and_starts_at_and_price_min(seance[:hall],
                                                                           seance[:starts_at],
                                                                           seance[:price_min],
                                                                           seance[:price_max])
              showing.update_attributes! seance
              showing.touch
            else
              showing = Showing.new(:hall => seance[:hall],
                                    :starts_at => seance[:starts_at],
                                    :price_min => seance[:price_min],
                                    :price_max => seance[:price_max],
                                    :affiche_id => movie.id).tap do |s|

                if place =~ /Факел/
                 s.place = 'Факел, центр досуга и спорта'
                 s.organization_id = 315
                else
                 s.place = cinematheatre.title
                 s.organization_id = cinematheatre.id
                end
              end
              showing.attributes = seance
              showing.save!
            end
          end
          bar.increment!
        end
        showings.where('starts_at > ?', now).where('updated_at <> ?', now).destroy_all
      else
        bar.increment! seances.count
      end
    end

    message = I18n.localize(Time.now, :format => :short) + " Импорт сеансов '#{place}' выполнен."
    Airbrake.notify(:error_class => "Rake Task", :error_message => message)
  end

  private
    def find_movie_by(title)
      Movie.find_by_title(title) || find_similar_movie_by(title)
    end

    def find_similar_movie_by(title)
      similar_movies = Movie.search{fulltext(title){fields(:title)}}.results
      if similar_movies.one?
        puts "Найден похожий фильм '#{title}' -> '#{similar_movies.first.title}'"
      else
        puts "Не могу найти фильм '#{title}'"

        message = I18n.localize(Time.now, :format => :short) + " Не могу найти фильм '#{title}'"
        Airbrake.notify(Exception.new(message))
      end
      similar_movies.first
    end

    def find_similar_cinematheatre_by(cinema_title)
      similar_cinematheatre = Organization.search{fulltext(cinema_title){fields(:title)}; fulltext('Кинотеатры'){fields(:category)}}.results
      if similar_cinematheatre.one?
        puts "Найден похожий кинотеатр '#{cinema_title}' -> '#{similar_cinematheatre.first.title}'"
      else
        puts "Кинотеатр '#{cinema_title}' не найден"

        message = I18n.localize(Time.now, :format => :short) + " Не могу найти кинотеатр '#{cinema_title}'"
        Airbrake.notify(Exception.new(message))
      end
      similar_cinematheatre.first
    end
end

namespace :sync do
  desc "Sync movie seances from http://fakel.tomsknet.ru"
  task :fakel => :environment do
    page = Nokogiri::HTML(open('http://fakel.tomsknet.ru/film_timetable.html'))
    puts 'Факел: парсинг'
    movies = {}
    day_nodes = page.css('table tr:nth-child(2) td:nth-child(3) table table')
    bar = ProgressBar.new(day_nodes.count)
    day_nodes.each do |day_node|
      rows = day_node.css('tr').to_a
      date = rows.shift.text.match(/((\d{2})\.(\d{2})\.(\d{4}))/)[1]
      rows.each do |seance|
        columns = seance.css('td').map(&:text)
        time = columns[0].match(/((\d{2}):(\d{2}))/)[1]
        starts_at  =  Time.zone.parse("#{date} #{time}")
        title = columns[1].gsub('(обычный формат)', '')
        price_min = columns[2].to_i
        movies[title] ||= []
        movies[title] << {starts_at: starts_at, price_min: price_min, price_max: price_min }
      end
      bar.increment!
    end

    MovieSyncer.new(:place => "Факел", :movies => movies).sync
  end

  desc "Sync movie seances from http://kinomax.tomsk.ru"
  task :kinomax => :environment do
    host = 'http://kinomax.tomsk.ru'
    url = "#{host}/schedule/"
    movies = {}

    timetable = Nokogiri::HTML(open(url).read).css('.tableTabContainer a')
    bar = ProgressBar.new(timetable.count)
    puts 'Киномакс: парсинг'

    timetable.each do |day_tile|
      day_schedule_path = day_tile.attribute('data-url').value
      date = day_schedule_path.match(/\d{2}.\d{2}.\d{4}/)
      day_schedule_page = Nokogiri::HTML(Net::HTTP.post_form(URI.parse(host + day_schedule_path), {}).body.force_encoding('cp1251'))

      day_schedule_page.css('h2.sectionHeader2').each do |hall_html|
        hall  = hall_html.text
        hall_html.next_element.css('div.hallContainer').each do |film|
          title = film.css('h3 a').text.squish
          three_d = title.match(/\(?3D\)?/)
          title = title.gsub(/\s\(?3D\)?\b|\(?2D\)?|\(?\d+\+\)?/,'').squish
          movies[title] ||= []
          film.css('a.timeLineItem').each do |seans|
            next if seans['class'].match(/session-already-past|session-disabled/)
            time = seans.css('u').first.text
            seans_id = seans['href'].match(/\d+/)
            prices = day_schedule_page.css("#sessionTooltip-#{seans_id}").first.css('table.sessionTooltipTable').first.css('td.tal')[1].text
            price_min = prices.match(/\d+/).to_a.map(&:to_i).min
            price_max = prices.match(/\d+/).to_a.map(&:to_i).max
            movies[title] << {
              :starts_at => Time.zone.parse("#{date} #{time}"),
              :hall => [hall, three_d].join(' ').squish,
              :price_min => price_min,
              :price_max => price_max }
          end
        end
      end
      bar.increment!
    end

    MovieSyncer.new(:place => "Киномакс", :movies => movies).sync
  end

  desc "Sync movie seances from http://kinomir.tom.ru"
  task :kinomir => :environment do
    host = 'http://kinomir.tom.ru'
    url = "#{host}/schedule/"
    movies = {}

    timetable = Nokogiri::HTML(open(url).read).css('.schedule a')
    bar = ProgressBar.new(timetable.count)
    puts 'Киномир: парсинг'

    timetable.each do |day_tile|
      day_schedule_path = day_tile.attribute('href').value
      date = day_schedule_path.match(/\d{2}.\d{2}.\d{4}/)
      day_schedule_page = Nokogiri::HTML(open(host+day_schedule_path).read)
      day_schedule_page.css('.raspisanie-table').each do |table|
        hall = table.css('thead tr td:first h1').text
        table.css('tbody tr td div .container .content').each do |seance|
          title = seance.css('h1').text
          three_d = title.match(/((?:в 3D)|3D)/).try(:[], 1)
          title = title.gsub(/((?:в 3D)\b|3D\b)/,'').squish
          next if title =~ /^Non-stop [[:alpha:]]+ зал$/
          movies[title] ||= []
          seance.parent.parent.parent.parent.css('td:nth-child(2) > div > div').each do |i|
            if i['class'] == 'show-time'
              time = i.css('a').text
              amount = i.next_element.css('table td:nth-child(2)').text
              if time.split(':').first == '24'
                hour = '00'
                min = time.split(':').last
                time = hour + ':' + min
                Time.parse(time)+1.day
              else
                Time.parse(time)
              end
              movies[title] << {:starts_at => Time.zone.parse("#{date} #{time}"), :hall => [hall, three_d].join(' ').squish, :price_min => amount.to_i, :price_max => amount.to_i }
            end
          end
        end
      end
      bar.increment!
    end

    MovieSyncer.new(:place => "Киномир", :movies => movies).sync
  end
end

task :sync => ['sync:fakel', 'sync:kinomax', 'sync:kinomir'] do
  bad_showings = Showing.where(:affiche_id => MovieSyncer.finded_movies.map(&:id).uniq).where('starts_at > ?', MovieSyncer.now).where('updated_at <> ?', MovieSyncer.now)
  bad_showings.destroy_all
end
