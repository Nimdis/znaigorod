# encoding: utf-8

require 'progress_bar'

desc "Пересчет рейтинга пользователей"
task :recalculate_accounts_rating => :environment do
  accounts = Account.all
  bar = ProgressBar.new(accounts.count)
  accounts.each do |account|
    account.update_rating
    bar.increment!
  end
end

