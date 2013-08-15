# encoding: utf-8

require 'progress_bar'

namespace :account do

  desc 'Make  everything'
  task :all => [:create, :get_vk_friends, :recalculate_rating]

  desc 'Create accounts for users'
  task :create => :environment do
    puts 'Create accounts'
    users = User.ordered
    bar = ProgressBar.new(users.count)
    users.each do |user|
      next if user.account
      user.create_account
      bar.increment!
    end
  end

  desc 'Get friends from vkontakte'
  task :get_vk_friends => :environment do
    puts 'Get vk friends'
    accounts = Account.ordered
    vk_client = VkontakteApi::Client.new
    bar = ProgressBar.new(accounts.count)
    accounts.each do |account|
      begin
        if account.users.vkontakte.any?
          user = account.users.vkontakte.first
          uids = vk_client.friends.get(user_id: user.uid)
          uids.each do |uid|
            if User.vkontakte.where(uid: uid.to_s).any?
              account.friends.create(friendable: account.get_account(uid.to_s),
                                     friendly: true) unless account.friends_with?(account.get_account(uid.to_s))
            end
          end
        end
        bar.increment!
      rescue
        next
      end
    end
  end

  desc "Пересчет рейтинга пользователей"
  task :recalculate_rating => :environment do
    puts 'Recalculate ratings'
    accounts = Account.all
    bar = ProgressBar.new(accounts.count)
    accounts.each do |account|
      account.update_rating
      bar.increment!
    end
  end
end
