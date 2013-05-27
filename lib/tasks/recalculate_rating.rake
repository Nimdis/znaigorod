# encoding: utf-8

require 'progress_bar'

def recalculate_rating(options={})
  clazz = options.delete(:class)
  puts "recalculate rating for #{clazz}"
  bar = ProgressBar.new(clazz.count)
  clazz.find_each do |object|
    object.recalculate_rating
    bar.increment!
  end
end

def recalculate_affiche_rating
  puts "recalculate rating for Affiche"
  affiches = Affiche.all
  bar = ProgressBar.new(affiches.count)
  affiches.each do |affiche|
    #affiche.recalculate_affiche_rating
    affiche.update_rating
    bar.increment!
  end
end

desc "Пересчет рейтинга организиции"
task :recalculate_rating => :environment do
  #recalculate_rating :class => Organization
  #Affiche.all.map(&:update_rating)
  recalculate_affiche_rating
end

