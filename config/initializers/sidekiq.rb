Sidekiq.configure_server do |config|
  config.redis = { :url => 'redis://redis.openteam.ru:6379/12', :namespace => 'znaigorod' }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => 'redis://redis.openteam.ru:6379/12', :namespace => 'znaigorod' }
end
