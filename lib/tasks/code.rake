namespace :code do
  desc "Run rubocop (syntax)"
  task :rubocop do
    system "rubocop"
  end

  desc "Run flay (duplication)"
  task :flay do
    system "flay -d app/"
  end

  desc "Run flog (complex code)"
  task :flog do
    system "flog -d app/"
  end
  
  desc "Pull all"
  task :pull do
    system "git pull"
    system "bundle install"
    system "bundle exec rake db:migrate"
    system "RAILS_ENV=test bundle exec rake db:migrate"
  end
end