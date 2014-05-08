source "http://rubygems.org"
#ruby "1.9.3", :engine => "rbx", :engine_version => "2.0.0.rc1"

gem "rails", "4.0.3"
gem "pg" , "~> 0.16.0"

gem "thin", "~> 1.5.1"
# gem "puma", "~> 2.6.0"

gem "memcachier", "~> 0.0.2"
gem "dalli", "~> 2.6.4"

gem "oj", "~> 2.1.7"
gem "json", "~> 1.8.0"

gem "omniauth", "~> 1.1.4"
gem "omniauth-facebook", "~> 1.4.1"
gem "omniauth-twitter", "~> 1.0.1"
gem "fb_graph", "~> 2.7.8"
gem "twitter", "~> 4.8.1"

gem "redis-rails", "~> 4.0.0"
gem "devise", "~> 3.1.0"
gem "activeadmin", github: "gregbell/active_admin", branch: "master", :ref => "2c1a16368fd5fb8122329eb61c848bbd0e516870"
gem "sidekiq", "~> 2.16.1"
gem "ransack", "~> 1.1.0"
gem "sanitize", "~> 2.0.6"

gem "active_link_to", "~> 1.0.0"
gem "kaminari", "~> 0.14.1"
gem "carrierwave", "~> 0.8.0"
gem "mini_magick", "~> 3.5.0"
gem "cloudinary", "~> 1.0.66"

gem "populator", require: false
gem "ffaker", require: false
# gem "mocha", require: false
gem "factory_girl_rails", require: false

group :assets do
  gem "sass-rails", "~> 4.0.0"
  gem "uglifier", ">= 1.3.0"
  gem "coffee-rails", "~> 4.0.0"
  gem "jquery-rails", "~> 3.0.4"
  gem "jquery-ui-rails", "~> 4.1.0"
  gem "therubyracer", "~> 0.12.0"
  gem "execjs", "~> 2.0.2"
end

group :production do
  gem "rails_12factor"
  gem "newrelic_rpm"
  gem "unicorn", "~> 4.6.3"
end

group :development do
  gem "quiet_assets"
  gem "annotate"
  gem "awesome_print"
  gem "better_errors"
  gem "binding_of_caller", "~> 0.7.2"
  gem "meta_request", "~> 0.2.8"
  gem "rb-readline", "~> 0.4.2"
  gem "letter_opener"
  gem "rails-footnotes", ">= 3.7.9"

  gem "rubocop", require: false
  gem "flog", require: false
  gem "flay", require: false
end

group :test, :development do
  gem "rspec-rails", "~> 2.14.0"

  gem "zeus", "~> 0.13.4.pre2", require: false
  # gem "guard", "~> 2.1.0"
  # gem "guard-rspec", "~> 4.0.3"

  gem "zip", "~> 2.0.2"
  gem "show_me_the_cookies"
  gem "capybara", "~> 2.1.0"
  gem "rspec-steps"
  gem "email_spec"
  # gem "capybara-webkit"
  gem "selenium-webdriver" ,"~> 2.34.0"
  gem "poltergeist","~> 1.3.0"
end
