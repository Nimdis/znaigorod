# encoding: utf-8

require 'progress_bar'

namespace :account do

  desc 'Make  everything'

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

  desc 'Get friends for account'
  task :get_friends => :environment do
    puts 'Get friends for accounts from socials'
    accounts = Account.ordered
    bar = ProgressBar.new(accounts.count)
    accounts.each do |account|
      account.users.first.get_friends_from_socials if account.users
      bar.increment!
    end
  end

end
