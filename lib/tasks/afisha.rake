# encoding: utf-8

require 'progress_bar'

namespace :afisha do

  desc 'Get users for afisha`s vkontakte event'
  task :event_users => :environment do
    puts 'Get users for afisha`s vkontakte event'
    afishas = Afisha.with_event_url
    users = User.all
    vk_client = VkontakteApi::Client.new(User.find(9).token)
    bar = ProgressBar.new(afishas.count)
    afishas.each do |afisha|
      begin
        uids = vk_client.groups.get_members(group_id: afisha.get_vk_event_id).users
        uids.each do |uid|
          if User.where(uid: uid.to_s).any?
            afisha.visits.find_or_create_by_user_id(user_id: User.find_by_uid(uid.to_s).id, visited: true)
          end
        end
        bar.increment!
      rescue
        next
      end
    end
  end

  desc 'Get likes count from social networks'
  task :likes => [:fb_likes, :vk_likes]

  desc 'Get facebook likes'
  task :fb_likes => :environment do
    afishas = Afisha.with_showings
    bar = ProgressBar.new(afishas.count)
    afishas.each do |afisha|
      if afisha.slug?
        url = "#{Settings[:app][:url]}/afisha/#{afisha.slug}"
        data = open("http://graph.facebook.com/?ids=#{URI.escape(url)}").read
        data = JSON.parse(data)
        afisha.update_attributes(fb_likes: data[url]['shares'])
      end
      bar.increment!
    end
  end

  desc 'Get vkontakte likes'
  task :vk_likes => :environment do
    afishas = Afisha.with_showings
    bar = ProgressBar.new(afishas.count)
    vk_client = VkontakteApi::Client.new
    afishas.each do |afisha|
      if afisha.slug?
        url = "#{Settings[:app][:url]}/afisha/#{afisha.slug}"
        begin
          likes = vk_client.likes.get_list(type: 'sitepage', owner_id: '3136085', page_url: url)['count']
          afisha.update_attributes(vkontakte_likes: likes)
        rescue VkontakteApi::Error => e
          next
        end
      end
      bar.increment!
    end
  end
end
