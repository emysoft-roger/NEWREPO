# encoding: utf-8
PRODUCTION_APP = 'louerunsenior'

task "deploy:test" => ['deploy:set_staging_app', 'deploy:push', 'deploy:migrate', 'deploy:tag']
task "deploy:test:populate" => ['deploy:set_staging_app', 'deploy:populate']
task "deploy:test:command" => ['deploy:set_staging_app', 'deploy:command']
task "deploy:test:config" => ['deploy:set_staging_app', 'deploy:config']
task "deploy:test:log" => ['deploy:set_staging_app', 'deploy:log']
task "deploy:test:log_tail" => ['deploy:set_staging_app', 'deploy:log_tail']

task "deploy:prod" => ['deploy:set_production_app', 'deploy:push', 'deploy:migrate', 'deploy:tag']
task "deploy:prod:command" => ['deploy:set_production_app', 'deploy:command']
task "deploy:prod:config" => ['deploy:set_production_app', 'deploy:config']
task "deploy:prod:log" => ['deploy:set_production_app', 'deploy:log']
task "deploy:prod:log_tail" => ['deploy:set_production_app', 'deploy:log_tail']

task "deploy:all" => ['deploy:test','deploy:prod']

def heroku(cmd)
  system "GEM_HOME='' BUNDLE_GEMFILE='' GEM_PATH='' RUBYOPT='' heroku #{cmd}"
end

namespace :deploy do
  #==================
  STAGING_APP = PRODUCTION_APP + '-test'

  task :set_staging_app do
    APP = STAGING_APP
  end

  task :set_production_app do
    APP = PRODUCTION_APP
  end

  task :push do
    puts 'Deploying site to Heroku ...'
    system "git push -f git@heroku.com:#{APP}.git master"
  end

  task :restart do
    puts 'Restarting app servers ...'
    heroku "restart --app #{APP}"
  end

  task :tag do
    release_name = "#{APP}_release-#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"
    puts "Tagging release as '#{release_name}'"
    puts `git tag -a #{release_name} -m 'Tagged release'`
    puts `git push --tags git@heroku.com:#{APP}.git`
  end

  task :migrate do
    puts 'Running database migrations ...'
    heroku "run rake db:migrate --trace --app #{APP}"
  end

  task :populate do
    puts 'Running populate ...'
    heroku "run rake db:populate --trace --app #{STAGING_APP}"
  end

  task :log do
    puts 'Running log ...'
    heroku "logs --app #{APP}"
  end

  task :log_tail do
    puts 'Running log ...'
    heroku "logs -t --app #{APP}"
  end

  task :command do
    puts 'Running Command ...'
    heroku "run rails c --app #{APP}"
  end

  task :config do
    puts 'Running Command ...'
    heroku "config --app #{APP}"
  end

  task :setup do
    puts 'Setup ...'
    [PRODUCTION_APP, STAGING_APP].each do |app|
      # heroku addons:add memcachedcloud
      heroku "apps:create #{app} --region eu"
      heroku "addons:add mandrill --app #{app}"
      heroku "addons:add memcachier --app #{app}"
      heroku "addons:add heroku-postgresql --app #{app}"
      heroku "addons:add rediscloud --app #{app}"
      heroku "addons:add newrelic --app #{app}"
    end
  end

  task :off do
    puts 'Putting the app into maintenance mode ...'
    heroku "maintenance:off --app #{APP}"
  end

  task :on do
    puts 'Taking the app out of maintenance mode ...'
    heroku "maintenance:on --app #{APP}"
  end
end