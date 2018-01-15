Contracts API
================

Contracts API is a simple Rails API designed to manage vendor contracts and its lifetime.

## Requirements

 * Ruby 2.4.1
 * PostgreSQL

## Getting Started

Clone the repository, install gems and setup the database by running:

```sh
git clone git@github.com:evandrodutra/contracts.git
cd contracts
bundle install
bundle exec bin/setup
bundle exec rails s
```

## Development

#### Running Tests

To run the test environment execute:

```sh
bundle exec rspec
```

## API Definitions

All requests must use `Content-Type: application/json`

### Authentication

For a private endpoint you must specify the Authorization header using the JWT token generated for your account, example:

```sh
curl -X GET -i -H "Authorization: Bearer MY_JWT_TOKEN" -H "Content-Type: application/json" "http://localhost:3000/contracts/:id"
```

### POST data body

All POST action that sends a content body must use the JSON-API format, example:

```json
{
  data: {
    attributes: {
      full_name: "Douglas Adams",
      email: "dm@example.com",
      password: "humans"
    }
  }
}
```

### Response format

When the response has a content body instead of only the HTTP status, the returned data follows the JSON-API format, example:

```json
{
  "data": {
    "id": "db22fed2-0c07-4737-be36-f082146fc8d4",
    "type": "users",
    "attributes": {
      "full-name": "Douglas Adams",
      "email": "dm@example.com",
      "jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiZGIyMmZlZDItMGMwNy00NzM3LWJlMzYtZjA4Mj"
    }
  }
}
```


### Response error format

When the response contains entity errors the response body returns its description and status, example:

```json
{
  "errors": [
    {
      "status": 422,
      "detail": "Full name should not be empty",
      "source": {
        "pointer": "/data/attributes/full_name"
      }
    },
    {
      "status": 422,
      "detail": "Email is already taken",
      "source": {
        "pointer": "/data/attributes/email"
      }
    }
  ]
}
```

## API Usage

#### POST /users

Crates a user and return its JWT token.

```sh
POST /users
Content-Type: "application/json"

{
  data: {
    attributes: {
      full_name: "Douglas Adams",
      email: "dm@example.com",
      password: "humans"
    }
  }
}
```

Attribute | Description
--------- | -----------
**full_name**   | user name
**email** | valid email
**password** | user password

##### Returns:

```sh
201 Created
Content-Type: "application/vnd.api+json"

{
  "data": {
    "id": "f3a17518-3c85-441b-bb99-448fd7da0a00",
    "type": "users",
    "attributes": {
      "full-name": "Douglas Adams",
      "email": "dm@example.com",
      "jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiZjNhMTc1MTgtM2M4NS00NDFiLWJiOTktNDQ4ZmQ3ZGEwYTAwIn0.8ilUS6nx8OlM1KLHvHV6_PE1pCoiaeq_TQczvLl6rzg",
      "created-at": "2018-01-15T12:54:31.818Z",
      "updated-at": "2018-01-15T12:54:31.818Z"
    }
  }
}
```

#### POST /contracts

Crates a contract for a given user-token and returns its data:

```sh
POST /contracts
Content-Type: "application/json"
Authorization: "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiZjNhMTc1MTgtM2M4NS00NDFiLWJiOTktNDQ4ZmQ3ZGEwYTAwIn0.8ilUS6nx8OlM1KLHvHV6_PE1pCoiaeq_TQczvLl6rzg"

{
  data: {
    attributes: {
      vendor: "DB",
      starts_on: "30-01-2018",
      ends_on: "30-12-2018",
      price: "328.79"
    }
  }
}
```

Attribute | Description
--------- | -----------
**vendor**   | vendor name
**starts_on** | contract start date
**ends_on** | contract end date
price | contract price

##### Returns:

```sh
201 Created
Content-Type: "application/vnd.api+json"

{
  "data": {
    "id": "2c31b4fb-ac16-4fce-8634-16f3dd2a093c",
    "type": "contracts",
    "attributes": {
      "vendor": "DB",
      "starts-on": "2018-01-30 00:00:00",
      "ends-on": "2018-12-30 00:00:00",
      "price": "328.79",
      "created-at": "2018-01-15T13:02:43.346Z",
      "updated-at": "2018-01-15T13:02:43.346Z"
    }
  }
}
```

#### GET /contracts/:id

Returns the contract for a given user-token and returns its data:

```sh
GET /contracts/2c31b4fb-ac16-4fce-8634-16f3dd2a093c
Content-Type: "application/json"
Authorization: "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiZjNhMTc1MTgtM2M4NS00NDFiLWJiOTktNDQ4ZmQ3ZGEwYTAwIn0.8ilUS6nx8OlM1KLHvHV6_PE1pCoiaeq_TQczvLl6rzg"
```

Attribute | Description
--------- | -----------
**id**   | contract id

##### Returns:

```sh
200 OK
Content-Type: "application/vnd.api+json"

{
  "data": {
    "id": "2c31b4fb-ac16-4fce-8634-16f3dd2a093c",
    "type": "contracts",
    "attributes": {
      "vendor": "DB",
      "starts-on": "2018-01-30 00:00:00",
      "ends-on": "2018-12-30 00:00:00",
      "price": "328.79",
      "created-at": "2018-01-15T13:02:43.346Z",
      "updated-at": "2018-01-15T13:02:43.346Z"
    }
  }
}
```

#### DELETE /contracts/:id

Deletes a contract for a given user-token:

```sh
DELETE /contracts/2c31b4fb-ac16-4fce-8634-16f3dd2a093c
Authorization: "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiZjNhMTc1MTgtM2M4NS00NDFiLWJiOTktNDQ4ZmQ3ZGEwYTAwIn0.8ilUS6nx8OlM1KLHvHV6_PE1pCoiaeq_TQczvLl6rzg"
```

Attribute | Description
--------- | -----------
**id**   | contract id

##### Returns:

```sh
204 No content
```
