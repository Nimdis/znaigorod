# encoding: utf-8

require 'progress_bar'

desc 'Get friends from vkontakte'
task :get_vk_friends => :environment do
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
            account.friends.create(friendable: account.get_account(uid.to_s), friendly: true) unless account.friends_with?(account.get_account(uid.to_s))
          end
        end
      end
      bar.increment!
    rescue
      next
    end
  end
end


