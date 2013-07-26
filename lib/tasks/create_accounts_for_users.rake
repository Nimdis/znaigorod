# encoding: utf-8

require 'progress_bar'

desc 'Create accounts for users'
task :create_accounts_for_users => :environment do
  users = User.ordered
  bar = ProgressBar.new(users.count)
  users.each do |user|
    name = user.name.split(' ')
    account = Account.create(first_name: name.first, last_name: name.last, nickname: user.nickname, location: user.location, created_at: user.created_at)
    user.update_attributes(account_id: account.id)
    bar.increment!
  end
end

