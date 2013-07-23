# encoding: utf-8

require 'progress_bar'

desc "Пересчет рейтинга пользователей"
task :recalculate_users_rating => :environment do
  users = User.all
  bar = ProgressBar.new(users.count)
  users.each do |user|
    user.update_rating
    bar.increment!
  end
end

