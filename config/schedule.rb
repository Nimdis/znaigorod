require File.expand_path('../directories.rb', __FILE__)

dir = Directories.new

if RUBY_PLATFORM =~ /freebsd/
  set :job_template, "/usr/local/bin/bash -l -i -c ':job' 1>#{dir.log('schedule.log')} 2>#{dir.log('schedule-errors.log')}"
else
  set :job_template, "/bin/bash -l -i -c ':job' 1>#{dir.log('schedule.log')} 2>#{dir.log('schedule-errors.log')}"
end

every :day, :at => '7:15 am' do
  rake 'sync:fakel'
end

every :day, :at => '7:20 am' do
  rake 'sync:kinomax'
end

every :day, :at => '7:25 am' do
  rake 'sync:kinomir'
end

every :day, :at => '5am' do
  rake "refresh_sitemaps"
  rake 'account:get_friends'
end

every 2.hours do
  rake 'afisha:event_users'
  rake 'social_likes'
end

every 1.hours do
  rake 'account:reindex'
end

every 5.minutes do
  rake 'refresh_copies'
end
