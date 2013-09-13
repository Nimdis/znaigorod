# encoding: utf-8

namespace :update_rating do

  desc "Обновление рейтинга пользователей"
  task :accounts => :environment do
    Account.all.map(&:update_rating)
  end

  desc "Обновление рейтинга афиши"
  task :afisha => :environment do
    Afisha.actual.readonly(false).map(&:update_rating)
  end

  desc "Обновление рейтинга организаций"
  task :organizations => :environment do
    Organization.all.map(&:update_rating)
  end

  desc "Обновление рейтинга обзоров"
  task :organizations => :environment do
    Post.all.map(&:update_rating)
  end
end
