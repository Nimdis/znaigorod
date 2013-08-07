# encoding: utf-8

require 'progress_bar'

namespace :account do

  desc 'Make  everything'
  task :all => [:create, :get_gender_and_email, :get_avatar, :get_vk_friends, :recalculate_rating]

  desc 'Create accounts for users'
  task :create => :environment do
    puts 'Create accounts'
    users = User.ordered
    bar = ProgressBar.new(users.count)
    users.each do |user|
      name = user.name.split(' ')
      account = Account.create(first_name: name.first,
                               last_name: name.last,
                               nickname: user.nickname,
                               location: user.location,
                               created_at: user.created_at)
      user.update_attributes(account_id: account.id)
      bar.increment!
    end
  end

  desc 'Get gender and email for accounts'
  task :get_gender_and_email => :environment do
    puts 'Get gender and email'
    accounts = Account.all
    bar = ProgressBar.new(accounts.count)
    accounts.each do |account|
      if account.users.any?
        user = account.users.first
        case user.gender
        when 1 || 'female'
          gender = :female
        when 2 || 'male'
          gender = :male
        else
          gender = nil
        end
        account.update_attributes(gender: gender, email: user.email)
        bar.increment!
      end
    end
  end

  desc 'Get avatar for account'
  task :get_avatar => :environment do
    puts 'Get avatars'
    accounts = Account.ordered
    fb_client = Koala::Facebook::API.new
    VkontakteApi.configure { |c| c.log_requests = false }
    vk_client = VkontakteApi::Client.new
    bar = ProgressBar.new(accounts.count)
    accounts.each do |account|
      begin
        if account.users.any?
          user = account.users.first
          case user.provider
          when 'vkontakte'
            image = vk_client.users.get(uid: user.uid,
                                        fields: :photo_200_orig).first.photo_200_orig
            account.update_attributes(avatar: image)
          when 'facebook'
            image = fb_client.get_picture(user.uid, type: 'large')
            account.update_attributes(avatar: image)
          when 'google_oauth2', 'odnoklassniki', 'mailru', 'yandex', 'twitter'
            account.update_attributes(avatar: user.avatar)
          end
        end
        bar.increment!
      rescue
        next
      end
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
