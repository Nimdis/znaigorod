# encoding: utf-8

require 'progress_bar'
require 'social_likes'

def skip_callbacks
  Vote.skip_callback(:save, :after, :update_account_rating)
end

desc 'Get social likes for afishas and organizations'
task :social_likes => :environment do
  skip_callbacks
  likes = SocialLikes.new

  ['Afisha','Organization'].each do |klass|
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
