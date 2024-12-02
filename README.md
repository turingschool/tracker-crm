# Tracker CRM by Turing School of Software and Design

## Overview
This app is a Rails backend API for a job tracking CRM tool. 

## Setup
Rails 7.1.5
Ruby 3.2.2

```
bundle install

rails db:create
rails db:migrate
rails db:seed
```

This app will run on port 3001 locally.

## Testing
This app uses RSpec for testing. 

```
bundle exec rspec
```

## API Documentation

### Users

#### Create a User
New users require a unique email address and a matching password and password confirmation.

Request:
```
POST /api/v1/users

Body:
{
  "name": "John Doe",
  "email": "john.doe@example.com",
  "password": "password",
  "password_confirmation": "password"
}
```

Successful Response:
```
Status: 201 Created
Body: {
    "data": {
        "id": "4",
        "type": "user",
        "attributes": {
            "name": "John Doe",
            "email": "john.doe@example.com"
        }
    }
}
```

Error Responses:
```
Status: 400 Bad Request
Body: {
    "message": "Email has already been taken",
    "status": 400
}
```

```
Status: 400 Bad Request
Body: {
    "message": "Password confirmation doesn't match Password",
    "status": 400
}
```

#### Get All Users
Request:
```
GET /api/v1/users
```

Successful Response:
```
Status: 200 OK
Body: {
    "data": [
        {
            "id": "1",
            "type": "user",
            "attributes": {
                "name": "Danny DeVito",
                "email": "danny_de_v"
            }
        },
        ...
        {
            "id": "4",
            "type": "user",
            "attributes": {
                "name": "John Doe",
                "email": "john.doe@example.com"
            }
        }
    ]
}
```

#### Get a User 
Request:
```
GET /api/v1/users/:id
```

Successful Response:
```
Status: 200 OK
Body: {
    "data": {
        "id": "3",
        "type": "user",
        "attributes": {
            "name": "Lionel Messi",
            "email": "futbol_geek"
        }
    }
}
```

#### Create a Session (Login)

Request:
```
POST /api/v1/sessions

Body:
{
  "email": "john.doe@example.com",
  "password": "password"
}
``` 

Successful Response:
```
Status: 200 OK

Body: {
    "data": {
        "id": "4",
        "type": "user",
        "attributes": {
            "name": "John Doe",
            "email": "john.doe@example.com"
        }
    }
}
```

Error Response:
```
Status: 401 Unauthorized

Body: {
    "message": "Invalid login credentials",
    "status": 401
}
```