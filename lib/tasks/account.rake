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

end
