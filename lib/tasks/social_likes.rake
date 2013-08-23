# encoding: utf-8

require 'progress_bar'
require 'social_likes'

desc 'Get social likes for afishas,organizations and posts'
task :social_likes => :environment do
  likes = SocialLikes.new

  ['Afisha','Organization', 'Post'].each do |klass|
    if klass == 'Afisha'
      collection = klass.constantize.with_showings
    else
      collection = klass.constantize.all
    end

    puts "Getting likes for #{klass}"
    bar = ProgressBar.new(collection.count)
    collection.each do |item|
      likes.damn_likes(item)
      bar.increment!
    end
  end
end
