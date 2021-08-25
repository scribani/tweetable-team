# Tweetable Team

## Before getting started

1. Clone this repo and get into it.

2. Rename `.env.sample` to `.env` and fill it up with your github credentials. (DB_HOST will be filled later)

3. Run `docker compose up`. This will give you your db_hots (critics-beta_xxxx_db_1)

4. On a different window run `docker compose exec client bash`.

5. Inside the bash terminal run the `bootstrap` command.

6. Go to your `.env` file and fill the DB_HOST variable with your db_host from step 3

7. Install all the gems with `bundle install`

8. Initialize your DB: `rails db:create db:migrate db:seed`

## About

### The app

You can access your running app looking at `localhost:3000`.

> To be able to see your app running on any browser, run it using `rails server -b 0.0.0.0`.
> Otherwise the server will start but you won't be able to see anything since the rails app is just showing for its local container.

### The database

The file `config/database.yml` is set to use the ENV variable DB_HOST, don't forget to fill it in your ENV file.

```ruby
default: &default
  adapter: postgresql
  encoding: unicode
  username: postgres
  password: <%= ENV['PGPASSWORD'] %>
  host: <%= ENV['DB_HOST'] %>
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
```

If you want to connect to your db from a GUI client, you can use the next credentials:

```
  username: postgres
  password: codeable
  host: localhost
  port: 54320
  database: <rails_db_dev_name>
```
