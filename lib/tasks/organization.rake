# encoding: utf-8

require 'progress_bar'

namespace :organization do

  desc 'Upload posters to vkontakte'
  task :posters_to_vk => :environment do
    puts 'Upload organization posters to vkontakte'
    organizations = Organization.where('logotype_url is not null') - Organization.where(logotype_url: "")
    bar = ProgressBar.new(organizations.count)
    organizations.each do |organization|
      organization.upload_poster_to_vk
      bar.increment!
    end
  end
end

