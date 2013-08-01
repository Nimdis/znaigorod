# encoding: utf-8

require 'progress_bar'

desc 'Get avatar for account'
task :get_avatar_for_account => :environment do
  accounts = Account.ordered
  fb_client = Koala::Facebook::API.new
  vk_client = VkontakteApi::Client.new
  bar = ProgressBar.new(accounts.count)
  accounts.each do |account|
    begin
      if account.users.any?
        user = account.users.first
        case user.provider
        when 'vkontakte'
          image = vk_client.users.get(uid: user.uid, fields: :photo_200_orig).first.photo_200_orig
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



