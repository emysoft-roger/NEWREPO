# encoding: utf-8
begin
  require 'sidekiq'
rescue
  Rails.logger.info('No Sidekiq gem')
end

worker_processes 2
timeout 30
preload_app true

before_fork do |server, worker|
   # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end

  if defined?(::Sidekiq)
    @worker_pid = spawn('RAILS_ENV=production bundle exec sidekiq')
    t = Thread.new do
      Process.wait(@worker_pid)
      Rails.logger.info('Worker died. Bouncing unicorn.')
      Process.kill 'QUIT', Process.pid
    end
    # Just in case
    t.abort_on_exception = true
  end

  if defined?(Resque)
    Resque.redis.quit
    Rails.logger.info('Disconnected from Redis')
  end

  sleep 0.5
end

after_fork do |server, worker|

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end

  if defined?(ActiveSupport::Cache::DalliStore) &&
     Rails.cache.is_a?(ActiveSupport::Cache::DalliStore)
    # Reset Rails's object cache
    # Only works with DalliStore
    Rails.logger.info('Cache flushed.')
    Rails.cache.reset
  end

  # if defined?(::Sidekiq)
  #   Sidekiq.configure_client do |config|
  #     config.redis = { size: 1, url: ENV["REDISCLOUD_URL"] }
  #   end

  #   Sidekiq.configure_server do |config|
  #     config.redis = { size: 5, url: ENV["REDISCLOUD_URL"] }
  #   end

  #   Rails.logger.info('Sidekiq lunched')
  # end

  if defined?(Resque)
    Resque.redis = ENV['REDIS_URI']
    Rails.logger.info('Connected to Redis')
  end
end
