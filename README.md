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

#### Update a user
Request:
```
PUT /api/v1/users/:id

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
Status: 200 OK
Body: {
    "data": {
        "id": "4",
        "type": "user",
        "attributes": {
            "name": "Nathan Fillon",
            "email": "firefly_captian"
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

### Job Applications

#### Create a Job Application

Request:
```
POST /api/v1/users/:user_id/job_applications

Body: {
    {
        position_title: "Jr. CTO",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Fingers crossed!",
        job_description: "Looking for Turing grad/jr dev to be CTO",
        application_url: "www.example.com",
        contact_information: "boss@example.com",
        company_id: id_1
      }
}
```

Successful Response:
```

Status: 200

{:data=>
  {:id=>"4",
   :type=>"job_application",
   :attributes=>
    {:position_title=>"Jr. CTO",
     :date_applied=>"2024-10-31",
     :status=>1,
     :notes=>"Fingers crossed!",
     :job_description=>"Looking for Turing grad/jr dev to be CTO",
     :application_url=>"www.example.com",
     :contact_information=>"boss@example.com",
     :company_id=>35}}
     }
```

Unsuccessful Response:
```
{:message=>"Company must exist and Position title can't be blank", :status=>400}
```

Unsuccessful Response(pre-existing application for user):
```
{:message=>"Application url You already have an application with this URL", :status=>400}
```

### Companies

Get login credentials

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

This response will have a token like this:
eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzM0MzUzMDJ9.O6FtfoVjcobUiBHfKmZNovtt57061ktlPx-UgIZFGaQ

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

Error Response if no token provided:

```
Status: 401 Unauthorized

Body: {
    "message": "Invalid login credentials",
    "status": 401
}
```
#### Create a company

Request:
```
post "/api/v1/users/userid/companies" 

Add the bearer token to the auth tab in postman and will be able to create a company now for that specific user. Make sure to have the token for that user.

raw json body: 
{
  "name": "New Company",
  "website": "www.company.com",
  "street_address": "123 Main St",
  "city": "New York",
  "state": "NY",
  "zip_code": "10001",
  "notes": "This is a new company."
}
```
Successful Response:
```
Status: 201 created

"data": {
        "id": "1",
        "type": "company",
        "attributes": {
            "name": "New Company",
            "website": "www.company.com",
            "street_address": "123 Main St",
            "city": "New York",
            "state": "NY",
            "zip_code": "10001",
            "notes": "This is a new company."
    }
}

```

Error response - missing params

Request:
```
{
    "name": "", 
    "website": "amazon.com", 
    "street_address": "410 Terry Ave N", 
    "city": "Seattle", 
    "state": "WA", 
    "zip_code": "98109", 
    "notes": "E-commerce"
}
```
Response:
```
{
    "message": "Name can't be blank",
    "status": 422
}
```

#### Get all companies
Request:

```
GET /api/v1/users/userid/companies

Authorization: Bearer Token - put in token for user
```
Successful Response:

```
Body:{
  {
    "data": [
        {
            "id": "1",
            "type": "company",
            "attributes": {
                "name": "Google",
                "website": "google.com",
                "street_address": "1600 Amphitheatre Parkway",
                "city": "Mountain View",
                "state": "CA",
                "zip_code": "94043",
                "notes": "Search engine"
            }
        },
        {
            "id": "2",
            "type": "company",
            "attributes": {
                "name": "New Company122",
                "website": "www.company.com",
                "street_address": "122 Main St",
                "city": "New York11",
                "state": "NY11",
                "zip_code": "10001111",
                "notes": "This is a new company111."
            }
        }
    ]
}
}
```

User with no companies:
```
{
    "data": [],
    "message": "No companies found"
}
```
No token or bad token response
```
{
    "error": "Not authenticated"
}
```

### Contacts

Get login credentials: <br>
`Refer to Companies "Get login credentials" above`

#### Get all contacts for a user
Request:

```
GET /api/v1/users/:user_id/contacts

Authorization: Bearer Token - put in token for user
```
Successful Response:

```
{
  "data": [
    {
      "id": "1",
      "type": "contacts",
      "attributes": {
        "first_name": "John",
        "last_name": "Smith",
        "company": "Turing",
        "email": "123@example.com",
        "phone_number": "(123) 555-6789",
        "notes": "Type notes here...",
        "user_id": 4
      }
  },
  {
    "id": "2",
    "type": "contacts",
    "attributes": {
      "first_name": "Jane",
      "last_name": "Smith",
      "company": "Turing",
      "email": "123@example.com",
      "phone_number": "(123) 555-6789",
      "notes": "Type notes here...",
      "user_id": 4
      }
    }
  ]
}
```
Successful response for users without saved contacts:

```
{
  "data": [],
  "message": "No contacts found"
}
```

#### Create a contact with required and optional fields.
New contacts require a unique first and last name. All other fields are optional.

Request:
```
POST /api/v1/users/:user_id/contacts
Authorization: Bearer Token - put in token for user

raw json body with all fields: 

{
  "contact": {
    "first_name": "Jonny",
    "last_name": "Smith",
    "company_id": 1,
    "email": "jonny@gmail.com",
    "phone_number": "555-785-5555",
    "notes": "Good contact for XYZ",
    "user_id": 7
  }
}

```
Successful Response:
```
Status: 201 created

{
    "data": {
        "id": "5",
        "type": "contacts",
        "attributes": {
            "first_name": "Jonny",
            "last_name": "Smith",
            "company_id": 1,
            "email": "jonny@gmail.com",
            "phone_number": "555-785-5555",
            "notes": "Good contact for XYZ",
            "user_id": 7
        }
    }
}

```

#### Contact Errors
401 Error Response if no token provided:

```
Status: 401 Unauthorized

Body: {
    "message": "Invalid login credentials",
    "status": 401
}
```

422 Error Response Unprocessable Entity: Missing Required Fields
If required fields like first_name or last_name are missing:

Request:
```
POST /api/v1/users/:user_id/contacts
Authorization: Bearer Token - put in token for user

raw json body:

 {
  "contact": {
    "first_name": "Jonny",
    "last_name": ""
  }
}
```
Error response - 422 Unprocessable Entity
```
{
    "error": "Last name can't be blank"
}
```

Error response - invalid email format

Request:
```
{
  "contact": {
    "first_name": "Johnny",
    "last_name": "Smith",
    "email": "invalid-email"
  }
}
```
Response: 422 Unprocessable Entity

```
{
    "error": "Email must be a valid email address"
}
```
Error response - invalid phone number format

Request:
```
{
  "contact": {
    "first_name": "Johnny",
    "last_name": "Smith",
    "email": "invalid-email"
  }
}
```
Response: 422 Unprocessable Entity

```
{
    "error": "Phone number must be in the format '555-555-5555'"
}
```