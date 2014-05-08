Sidekiq.configure_client do |config|
  config.redis = { size: 1, url: ENV["REDISCLOUD_URL"] }
end

Sidekiq.configure_server do |config|
  config.redis = { size: 5, url: ENV["REDISCLOUD_URL"] }
end