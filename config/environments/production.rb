# encoding: utf-8
LouerunseniorRails::Application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = true
  config.assets.js_compressor = :uglifier
  config.assets.compile = true
  config.assets.digest = true
  config.assets.version = '1.0'
  config.log_level = :info
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.static_cache_control = "public, max-age=0"
  # config.static_cache_control = "public, max-age=30000000"
  config.cache_store = :dalli_store
  config.session_store = :redis_store, { servers: ENV["REDISCLOUD_URL"] }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { host: "http://louerunsenior.com" }
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.smtp_settings = {
    address: "smtp.mandrillapp.com",
    port: 587,
    user_name: ENV["MANDRILL_USERNAME"],
    password: ENV["MANDRILL_APIKEY"],
    authentication: "plain"
  }

end
