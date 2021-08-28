# Tweetable

This is a platform where you can interact with others by sharing your thoughts and liking their content.

## Getting Started

These instructions will give you a copy of the project up and running on your local machine for testing purposes.

### Installing

These are a step by step series of examples that tell you how to get a development environment running

1. Clone this repo and get into it
2. Create a `.env` file an complete the fields

```
# This info will be used if you choose to sign in using a GitHub account
GITHUB_KEY=*
GITHUB_SECRET=*

# The authorization callback URL is:
# http://localhost:3000/users/auth/github/callback
```

4. Run `docker compose up`. This will give you your db_host (something similar to tweetable_xxxx_db_1)
5. On a different window run `docker compose exec client bash`
6. Go to your `.env` file and add a field with your db_host from step 3

```
DB_HOST=tweetable_xxxx_db_1
```

7. Install all the gems with `bundle install`
8. Initialize your DB by running `rails db:create db:migrate db:seed`
9. To be able to see your app running on any browser, run it using `rails server -b 0.0.0.0`

> Otherwise the server will start but you won't be able to see anything since the rails app is just showing for its local container.

10. [Open](http://9.Open) a new window in your browser and go to `localhost:3000`
11. If you want to interact with the RESTful API you can make use of the insomnia file provided within the project

## Running the tests

Automated tests were made using RSpec, so to run the tests you need to execute `bundle exec rspec`

### API Tests

These will test all API endpoints and look for an appropriate response from the server on each request

```
EXAMPLE
get '/api/tweets' will expect a response with status code 200 and that returns a json with all the tweets
```

## Authors

- Ana Isabel León - [anaisabelLM](https://github.com/anaisabelLM)
- Andrés Scribani - [scribani](https://github.com/scribani)
- Adrian De la Cruz - [alxdrian](https://github.com/alxdrian)
- Julio Regalado - [Dulces123](https://github.com/Dulces123)

## Acknowledgments

- To the great staff at [codeableorg](https://github.com/codeableorg) for sharing all the knowledge and good practices