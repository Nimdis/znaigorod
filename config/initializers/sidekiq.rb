Sidekiq.configure_server do |config|
  config.redis = { :url => Settings[:redis][:url], :namespace => 'znaigorod-dev' }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => Settings[:redis][:url], :namespace => 'znaigorod-dev' }
end
