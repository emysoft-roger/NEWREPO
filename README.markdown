# Database

### PostgreSQL
You need PostgreSQL to run the project. Start it and create a user.

# Session and Cache

### Redis
Install Redis on your machine and start it. Nothing more.
### No Redis
If you can't, Session and Cache will be done in memory.

# Workflow

### General
1) Pull
    
    git pull

2) Install

    bundle install

3) Run migrations

    bundle exec rake db:migrate
    RAILS_ENV=test bundle exec rake db:migrate

You can run this 3 command with:

    bundle exec rake code:pull

### Server
1) Start zeus if note started

    zeus start

2) Run server (in another shell)

    zeus server

You can start a server without Zeus

    bundle exec rails start

# Deploy
Staging:

    zeus rake deploy:test

Production:

    zeus rake deploy:prod

Both:

    zeus rake deploy:all

# Fake Data

    bundle exec rake db:populate

Admin:

    http://localhost:3000/admin

    user:
    admin@local.dev

    pass:
    admin@local.dev

En dev, email = mot de pass (pour entreprise et expert)