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

every 4.hours do
  rake 'statistics:all'
end

every :day, :at => '3am' do
  rake "recalculate_rating"
end

every :day, :at => '5am' do
  rake "refresh_sitemaps"
end

every 5.minutes do
  rake "release_tickets"
end
