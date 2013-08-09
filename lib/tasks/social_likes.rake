# encoding: utf-8

require 'progress_bar'
require 'social_likes'

desc 'Get social likes for afishas and organizations'
task :social_likes => :environment do
  likes = SocialLikes.new

  ['Afisha','Organization'].each do |klass|
    if klass == 'Afisha'
      collection = klass.constantize.last(20)
    else
      collection = klass.constantize.last(20)
    end

    [:vkontakte_likes, :fb_likes, :odn_likes].each do |attr|
      puts "Getting #{attr.to_s} for #{klass}"
      bar = ProgressBar.new(collection.count)
      collection.each do |item|
        item.update_attributes(attr => likes.send(attr, item))
        bar.increment!
      end
    end
  end
end
