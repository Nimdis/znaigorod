# encoding: utf-8

require 'progress_bar'

namespace :afisha do

  desc 'Get users for afisha`s vkontakte event'
  task :event_users => :environment do
    puts 'Get users for afisha`s vkontakte event'
    afishas = Afisha.with_event_url
    vk_client = VkontakteApi::Client.new(User.find(9).token)
    bar = ProgressBar.new(afishas.count)
    afishas.each do |afisha|
      begin
        uids = vk_client.groups.get_members(group_id: afisha.get_vk_event_id).users
        uids.each do |uid|
          if User.where(uid: uid.to_s).any?
            afisha.visits.find_or_create_by_user_id(user_id: User.find_by_uid(uid.to_s).id)
          end
        end
        bar.increment!
      rescue
        next
      end
    end
  end

  desc 'Upload posters to vkontakte'
  task :posters_to_vk => :environment do
    puts 'Upload afishas posters to vkontakte'
    afishas = Afisha.with_showings.published
    bar = ProgressBar.new(afishas.count)
    afishas.each do |afisha|
      afisha.upload_poster_to_vk
      bar.increment!
    end
  end
end
