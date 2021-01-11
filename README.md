# Gifts API Exercise

The instructions were based on the project template provided in the exercise:

Simplecov test coverage: 100%

## Configuration
Rails and Ruby versions: Defined on the Gemfile

The app has the following tools preinstalled and configured:
  - Rspec
  - Factorybot
  - Faker
  - Database Cleaner
  - Shoulda Matchers

# Getting Started

After cloning the repo:
### Install the gems

```
bundle install
```
### Setup the database

Run docker-compose

```
docker-compose -f docker-compose.dev.yml up -d
```

Create test database

```
psql -h 127.0.0.1 -U apptegy gifts_api_development -p 31027
* The database password is: apptegy

CREATE DATABASE gifts_api_test;
```
### Migrate the database and seed

```
bundle exec rake db:migrate
bundle exec rake db:seed
```

### Start the server

You need to start docker-compose first

```
bundle exec rails s -p 3027
```
# API Documentation
The documentation is available through SwaggerHub in the following link:

https://app.swaggerhub.com/apis-docs/danielpg95/apptegy-gifts-api/0.1-oas3#/

The API documentation is configured to create requests to the cloud-server-hosted API in Heroku.
(https://salty-reaches-66640.herokuapp.com/v1)

Keep in mind that all requests (except the authentication endpoint) require an authorization token that
can be obtained using the authentication endpoint.
The authentication endpoint requires the following credentials in the body:
```
{
  "username": "apptegy",
  "password": "apptegy"
}
```
(A User object with those credentials was seeded to provide this functionality)

The token can be set using the authorize button on the page. (header key name is Authorization)

**Keep in mind that the API has a free dyno, so the first request will probably fail by timeout while the dyno gets up**