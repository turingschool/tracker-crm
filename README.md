# Tracker CRM by Turing School of Software and Design

<a id="readme-top"></a>

## Table of Contents

- [Overview](#overview)
- [Setup](#setup)
- [Testing](#testing)
- [Authentication, User Roles, and Authorization](#authentication-user-roles-and-authorization)
- [API Documentation](#api-documentation)
  - [Users](#users)
    - [Create a User](#create-a-user)
    - [Get all Users](#get-all-users)
    - [Get a User](#get-a-user)
    - [Update a User](#update-a-user)
    - [Create a Session](#create-a-session)
  - [Job Applications](#job-applications)
    - [Get all Job Applications](#get-all-job-applications-for-a-user)
    - [Create a Job Application](#create-a-job-application)
    - [Get a Job Application](#get-a-job-application)
    - [Update a Job Application](#update-a-job-application)
  - [Interview Questions](#interview-quesstions/fetch_or_create)
    - [Create AI Generated Interview Questions ](#create-ai-generated-interview-question-for-a-job-application)
  - [Companies](#companies)
    - [Create a Company](#create-a-company)
    - [Get all Companies](#get-all-companies)
  - [Contacts](#contacts)
    - [Get all Contacts](#get-all-contacts-for-a-user)
    - [Create a Contact](#create-a-contact-with-required-and-optional-fields)
    - [Create a Contact within a Company](#create-a-contact-with-a-company-name-from-the-dropdown-box)
    - [Show a Contact](#show-a-contact-that-belongs-to-a-user-not-company-contact)
  - [User Dashboard](#user-dashboard)
    - [Get Dashboard](#get-dashboard)
- [Contributors](#contributors)

## Overview

This app is a Rails backend API for a job tracking CRM tool that allows users to save lists of job applications, companies, and professional contacts under a personal account. The frontend repo that consumes this API lives here: https://github.com/turingschool/tracker-crm-fe. 

This project is the product of the efforts of 35+ Turing students working collaboratively across several graduating classes. A full list of contributors can be found at the bottom of this README, along with a list of licenses. 

## Setup

### Install Postgres User

```
createuser -s postgres

psql -d template1 -c "ALTER USER postgres WITH PASSWORD 'trackercrm';"
```

This app will run on port 3001 locally.

### Rails Install

Rails 7.1.5
Ruby 3.2.2

```
bundle install

rails db:create
rails db:migrate
rails db:seed
```

---
## ATTENTION ALL CONTRIBUTORS
### ⚠️ Security Scanning with Brakeman (REQUIRED)
- To maintain a high level of security in this project, all contributors must run [Brakeman](https://brakemanscanner.org/) prior to submitting a pull request.

#### ✅ How to Run Brakeman
- Before pushing your code or submitting a PR, run the following command in the root of the Rails project:
`brakeman -A -q -o bm-report.md`

- This will generate a security report in a markdown file [bm-report.md](/bm-report.md).

#### 📋 Include Brakeman Results in Your PR

After creating your pull request, copy and paste the contents of the [bm-report.md](/bm-report.md) file into your PR description between the following comments:

```
### Brakeman Results (REQUIRED):
<!--- Copy and paste your bm-report.md -->

<!--- Between these two comments -->
```

## Security Warnings
- If Brakeman includes any `security warnings` in the report, please notify the project manager and create a backlog card on the project board to review and research any possible security vulnerabilities.

| Scanned/Reported  | Total |
|-------------------|-------|
| Controllers       | 8     |
| Models            | 8     |
| Templates         | 1     |
| Errors            | 0     |
| Security Warnings | 0 (0) |
---

## Testing

#### This app uses RSpec for testing:
`bundle exec rspec`

###### Models:
`bundle exec rspec /spec/models`

###### Requests:
`bundle exec rspec /spec/requests/api/v1`

###### Gateways:
`bundle exec rspec /spec/gateways`

---

## Testing with Factorybot
 - This application utilizes FactoryBot to streamline the creation of test data for RSpec. 
 - Factories allow us to generate consistent, reusable test objects without manually setting up database records.

#### FactoryBot Commands w/ Test Files:

`create(:user)` - Autogenerate a user with the "user" role that gets added to the test database and validates with ActiveRecord
`build(:user)` - Autogenerate a user with the "user" role that will not get validated with ActiveRecord

`create(:company)` - Autogenerate a company and user that gets added to the test database and validates with ActiveRecord
`build(:company)` - Autogenerate a company and user that will not get validated with ActiveRecord

`create(:contact)` - Autogenerate a contact, company, and user that gets added to the test database and validates with ActiveRecord.
`build(:contact)` - Autogenerate a contact, company, and user that will not get validated with ActiveRecord

`create(:job_application)` - Autogenerate a job application, company, and user that gets added to the test database and validates with ActiveRecord.
`build(:job_application)` - Autogenerate a job application, company, and user that will not get validated with ActiveRecord

#### FactoryBot Commands w/ Rails Console:
- Launch Rails Console:
`rails console`

`FactoryBot.create(:user)` - Autogenerate a user with the "user" role that gets added to the development database and validates with ActiveRecord
`FactoryBot.build(:user)` - Autogenerate a user with the "user" role that will not get validated with ActiveRecord

`FactoryBot.create(:company)` - Autogenerate a company and user that gets added to the development database and validates with ActiveRecord
`FactoryBot.build(:company)` - Autogenerate a company and user that will not get validated with ActiveRecord

`FactoryBot.create(:contact)` - Autogenerate a contact, company, and user that gets added to the development database and validates with ActiveRecord.
`FactoryBot.build(:contact)` - Autogenerate a contact, company, and user that will not get validated with ActiveRecord

`FactoryBot.create(:job_application)` - Autogenerate a job application, company, and user that gets added to the development database and validates with ActiveRecord.
`FactoryBot.build(:job_application)` - Autogenerate a job application, company, and user that will not get validated with ActiveRecord

---

<p align="right">(<a href="#readme-top">back to top</a>)</p>

# Authentication, User Roles, and Authorization

- Authentication is handled by the [JWT(Json Web Token) Gem](https://github.com/jwt/ruby-jwt/blob/main/README.md)  
  More info: [Understanding JWT(Json Web Token) Gem](#understanding-jwtjson-web-token-gem)
- User Roles is handled by the [Rolify Gem](https://github.com/RolifyCommunity/rolify/blob/master/README.md)  
  More info:[Understanding the Rolify Gem](#understanding-the-rolify-gem)
- Authorization is enforced by the [Pundit Gem](https://github.com/varvet/pundit/blob/main/README.md)  
  More info:[Understanding the Pundit Gem](#understanding-the-pundit-gem)

## API Documentation

Postman Collection can be found in Tracker-crm.postman_collection.json

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

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}
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

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}
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

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}

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
  "token": {user_token},
  "user" : {
    "data": {
      "id": "4",
      "type": "user",
      "attributes": {
        "name": "John Doe",
        "email": "john.doe@example.com"
      }
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

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Job Applications

#### Get all Job Applications for a user

Request:

```
GET /api/v1/users/:user_id/job_applications

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}
```

Successful Response:

```
Status: 200

{
    "data": [
        {
            "id": "1",
            "type": "job_application",
            "attributes": {
                "position_title": "Jr. CTO",
                "date_applied": "2024-10-31",
                "status": 1,
                "notes": "Fingers crossed!",
                "job_description": "Looking for Turing grad/jr dev to be CTO",
                "application_url": "www.example.com",
                "contact_information": "boss@example.com",
                "company_id": 1,
                "company_name": "Google"
            }
        },
        {
            "id": "3",
            "type": "job_application",
            "attributes": {
                "position_title": "Backend Developer",
                "date_applied": "2024-08-20",
                "status": 2,
                "notes": "Had a technical interview, awaiting decision.",
                "job_description": "Developing RESTful APIs and optimizing server performance.",
                "application_url": "https://creativesolutions.com/careers/backend-developer",
                "contact_information": "techlead@creativesolutions.com",
                "company_id": 3,
                "company_name": "Amazon"
            }
        }
    ]
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

#### Create a Job Application

Request:

```
POST /api/v1/users/:user_id/job_applications

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}

Body: {
    {
        position_title: "Jr. CTO",
        date_applied: "2024-10-31",
        status: 1,
        notes: "Fingers crossed!",
        job_description: "Looking for Turing grad/jr dev to be CTO",
        application_url: "www.example.com",
        contact_id: "1",
        company_id: "1"
      }
}

```

Successful Response:

```

Status: 200

"data": [
        {
            "id": "1",
            "type": "job_application",
            "attributes": {
                "position_title": "Jr. CTO",
                "date_applied": "2024-10-31",
                "status": 1,
                "notes": "Fingers crossed!",
                "job_description": "test"
                "application_url": "www.example.com",
                "company_id": 1,
                "company_name": "Tech Innovators",
                "contact_id": null,
                "updated_at": "2025-02-11",
                "contacts": [
                    {
                        "id": 1,
                        "first_name": "John",
                        "last_name": "Doe",
                        "email": "john.doe@example.com",
                        "phone_number": "123-555-1234",
                        "notes": "Recruiter at Tech Innovators"
                    },
                ]
            }
        }
]

```

Unsuccessful Response:

```

{:message=>"Company must exist and Position title can't be blank", :status=>400}

```

#### Get a Job Application

Request:

```

GET /api/v1/users/:user_id/job_applications/:job_application_id

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}

```

Successful Response:

```

{
  "data": {
    "id": "3",
    "type": "job_application",
    "attributes": {
      "position_title": "Backend Developer",
      "date_applied": "2024-08-20",
      "status": 2,
      "notes": "Had a technical interview, awaiting decision.",
      "job_description": "Developing RESTful APIs and optimizing server performance.",
      "application_url": "https://creativesolutions.com/careers/backend-developer",
      "company_id": 3,
      "company_name": "Creative Solutions Inc.",
      "contacts": [
        {
          "id": 3,
          "first_name": "Michael",
          "last_name": "Johnson",
          "email": "michael.johnson@example.com",
          "phone_number": "123-555-9012",
          "notes": "Hiring manager at Creative Solutions Inc."
        }
      ]
    }
  }
}

```

Unsuccessful Response(job application does not exist OR belongs to another user):

```

{
"message": "Job application not found",
"status": 404
}

```

<!--
Unsuccessful Response(missing job application ID param):
```

{:message=>"Job application ID is missing", :status=>400}

```-->

If the user is not authenticated:

```

{
"message": "Unauthorized request",
"status": 401
}

```

Unsuccessful Response(pre-existing application for user):

```

{:message=>"Application url You already have an application with this URL", :status=>400}

```

#### Update a Job Application

Request:

```

PATCH /api/v1/users/:user_id/job_applications/:job_application_id

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}


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

Minimum of one attribute needs to be changed in the update for it to be successful
<br>
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
      :company_id=>35,
      :updated_at=>"2025-01-07"
    }
  }
}

```

Unsuccessful Response:

```

{:message=>"No parameters provided", :status=>400}

```

No parameters were recognized by the application, check the request parameters to see that they match.

```

{:message=>"Job application not found", :status=>404}

```

Either the application doesn't exist or it doesn't belong to the current user. Verify that it exists and matches the user identity in the token.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

#### Create AI Generated Interview Questions (or fetch if they already exist)

Request:
```
GET "/api/v1/users/userid/job_applications/job_applicationid/interview_questions/fetch_or_create

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}

```

Successful Response:

```
Status: 200 ok

{
    "id": "existing-questions-for-userid",
    "data": [
        {
            "index": 1,
            "type": "interview_question",
            "attributes": {
                "question": "This is a question?"
            }
        },
        {
            "index": 2,
            "type": "interview_question",
            "attributes": {
                "question": "This is a question?"
            }
        },
        {
            "index": 3,
            "type": "interview_question",
            "attributes": {
                "question": "This is a question?"
            }
        },
        {
            "index": 4,
            "type": "interview_question",
            "attributes": {
                "question": "This is a question?"
            }
        },
        {
            "index": 5,
            "type": "interview_question",
            "attributes": {
                "question": "This is a question?"
            }
        },
        {
            "index": 6,
            "type": "interview_question",
            "attributes": {
                "question": "This is a question?"
            }
        },
        {
            "index": 7,
            "type": "interview_question",
            "attributes": {
                "question": "This is a question?"
            }
        },
        {
            "index": 8,
            "type": "interview_question",
            "attributes": {
                "question": "This is a question?"
            }
        },
        {
            "index": 9,
            "type": "interview_question",
            "attributes": {
                "question": "This is a question?"
            }
        },
        {
            "index": 10,
            "type": "interview_question",
            "attributes": {
                "question": "This is a question?"
            }
        }
    ]
}
        
```
Serializer: This serializer formats both the InterviewQuestion model instances (when fetching from database) and raw question strings (when newly generated from OpenAI). The map.with_index(1) starts indexing at 1 instead of 0, making the question numbers more human-readable (Question 1, 2, 3... instead of 0, 1, 2...).

```
{
  id: response_id,
  data: questions.map.with_index(1) do |question, index|
    {
      index: index, 
      type: "interview_question",
      attributes: {
        question: question.respond_to?(:question) ? question.question : question
      }
    }
  end
}
```
### Companies

#### Create a company

Request:

```
POST "/api/v1/users/:userid/companies"

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}

Body:
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

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}

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

#### Delete a Company

Request:

```
DELETE /api/v1/users/:userid/companies/:id
Headers:
{
  "Authorization": "Bearer <your_token_here>"
}

```

Successful Response:

```
Status: 200 OK
{
  "message": "Company successfully deleted"
}

```

Error Responses:

Company Not Found

DELETE /api/v1/users/:userid/companies/9999
Response:

```

Status: 404 Not Found
{
  "error": "Company not found"
}

```

Unauthorized: No Token Provided

DELETE /api/v1/users/:userid/companies/:id
Response:

```

Status: 401 Unauthorized
{
  "error": "Not authenticated"
}

```

Unauthorized: Invalid Token

DELETE /api/v1/users/:userid/companies/:id
Headers:

```

{
  "Authorization": "Bearer invalid.token.here",
  "Content-Type": "application/json"
}

```

Response:
Status: 401 Unauthorized

```

{
  "error": "Not authenticated"
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

#### Edit a company

Request:

```

PATCH /api/v1/users/:user_id/companies/:company_id

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}

Body:
{
  "name": "New Name"
}

```

Successful Response:

```

{
    "data": [
        {
            "id": "2",
            "type": "company",
            "attributes": {
                "name": "New Name",
                "website": "https://futuredesigns.com",
                "street_address": "456 Future Blvd",
                "city": "Austin",
                "state": "Texas",
                "zip_code": "73301",
                "notes": "Submitted application for the UI Designer role."
            }
        }
    ]
}
```

Request with empty body:

```

{
  "message": "No updates provided",
  "status": 400
}

```

Request with empty value:

```

{
  "message": "Name can't be blank",
  "status": 422
}

```

Multiple attributes can be updated at once but none of the values can be blank or it will error out.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Contacts

#### Get all contacts for a user

Request:

```

GET /api/v1/users/:user_id/contacts

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}

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

#### Create a Contact with required and optional fields.

**_New contacts require a unique first and last name. All other fields are optional._**

Request:

```

POST /api/v1/users/:user_id/contacts
Headers:
{
  "Authorization": "Bearer <your_token_here>"
}

Body:{
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

#### Create a contact with a company name from the dropdown box

**_New contacts with company name require a unique first and last name, and company ID in the URI. All other fields are optional._**

Request:

```

POST api/v1/users/:user_id/companies/:company_id/contacts

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}

Body:
{
  "contact":{
    "first_name": "Jane",
    "last_name": "Doe",
    "company_id": 2,
    "email": "",
    "phone_number": "",
    "notes": "",
    "user_id": 2,
    "company": {
        "id": 2,
        "name": "Future Designs LLC",
        "website": "https://futuredesigns.com",
        "street_address": "456 Future Blvd",
        "city": "Austin",
        "state": "TX",
        "zip_code": "73301",
        "notes": "Submitted application for the UI Designer role."
    }
  }
}
```

#### Show a Contact that belongs to a User (not company contact)

**_Ensure you Create the Contact first for the user NOT company - 2 different Routes!_**

Request:

```

GET http://localhost:3001/api/v1/users/:user_id/contacts/:contact_id

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}

```

Successful Response:

```

{
    "data": {
        "id": "1",
        "type": "contacts",
        "attributes": {
            "first_name": "Josnny",
            "last_name": "Smsith",
            "company_id": 1,
            "email": "jonny@gmail.com",
            "phone_number": "555-785-5555",
            "notes": "Good contact for XYZ",
            "user_id": 1,
            "company": {
                "id": 1,
                "name": "Tech Innovators",
                "website": "https://techinnovators.com",
                "street_address": "123 Innovation Way",
                "city": "San Francisco",
                "state": "CA",
                "zip_code": "94107",
                "notes": "Reached out on LinkedIn, awaiting response."
            }
        }
    }
}
```

#### Edit a Contact

**_Change at least one value_**

Request:

```

PATCH /api/v1/users/:user_id/contacts/:contact_id

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}

Body:

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

Contact without associated company:
Status: 200 ok

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

Contact with associated company:
Status: 200 ok

{
    "data": {
        "id": "9",
        "type": "contacts",
        "attributes": {
            "first_name": "Jonny",
            "last_name": "Jonny",
            "company_id": 1,
            "email": "jj@gmail.com",
            "phone_number": "555-785-5555",
            "notes": "Good contact for XYZ",
            "user_id": 7,
            "company": {
                "id": 1,
                "name": "Tech Innovators",
                "website": "https://techinnovators.com",
                "street_address": "123 Innovation Way",
                "city": "San Francisco",
                "state": "CA",
                "zip_code": "94107",
                "notes": "Reached out on LinkedIn, awaiting response."
            }
        }
    }
}

```

#### Delete a Contact

Request:

```

DELETE http://localhost:3001/api/v1/users/:user_id/contacts/:id

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}

```

Successful Response:

```

{
"message": "Contact deleted successfully"
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

Status: 404 Not Found:

```

{
  "message": "Contact not found or unauthorized access",
  "status": 404
}

```

422 Error Response Unprocessable Entity: Missing Required Fields
If required fields like first_name or last_name are missing:

Request:

```

POST /api/v1/users/:user_id/contacts

Headers:
{
  "Authorization": "Bearer <your_token_here>"
}

Body:
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

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### User Dashboard

Get login credentials: <br>
`Refer to "Create a Session" above`

**Make sure to not only create/login a user, but to have that user also create a Company/Job Application/Contact for your Postman scripts. Refer to above endpoints to do so and make sure that user is the one creating the other resources**

#### Get Dashboard

Request:

```

GET /api/v1/users/:user_id/dashboard

Authorization: Bearer Token - put in token for user

```

Successful Response:

```

{
"data": {
"id": "5",
"type": "dashboard",
"attributes": {
"id": 5,
"name": "Danny DeVito",
"email": "danny_de@email.com",
"dashboard": {
"weekly_summary": {
"job_applications": [
{
"id": 1,
"position_title": "Jr. CTO",
"date_applied": "2024-10-31",
"status": 1,
"notes": "Fingers crossed!",
"job_description": "Looking for Turing grad/jr dev to be CTO",
"application_url": "www.example.com",
"contact_information": "boss@example.com",
"created_at": "2024-12-14T17:20:41.979Z",
"updated_at": "2024-12-14T17:20:41.979Z",
"company_id": 1,
"user_id": 5
},
{
"id": 2,
"position_title": " CTO",
"date_applied": "2024-10-31",
"status": 2,
"notes": "Fingers crossed!",
"job_description": "Looking for Turing grad/jr dev to be CTO",
"application_url": "www.testexample.com",
"contact_information": "boss1@example.com",
"created_at": "2024-12-14T17:37:28.465Z",
"updated_at": "2024-12-14T17:37:28.465Z",
"company_id": 2,
"user_id": 5
}
],
"contacts": [
{
"id": 1,
"first_name": "Jonny",
"last_name": "Smith",
"email": "jonny@gmail.com",
"phone_number": "555-785-5555",
"notes": "Good contact for XYZ",
"created_at": "2024-12-14T17:55:21.875Z",
"updated_at": "2024-12-14T17:55:21.875Z",
"user_id": 5,
"company_id": 1
},
{
"id": 2,
"first_name": "Josnny",
"last_name": "Smsith",
"email": "jonny@gmail.com",
"phone_number": "555-785-5555",
"notes": "Good contact for XYZ",
"created_at": "2024-12-15T01:57:14.557Z",
"updated_at": "2024-12-15T01:57:14.557Z",
"user_id": 5,
"company_id": 1
}
],
"companies": [
{
"id": 1,
"user_id": 5,
"name": "New Company",
"website": "www.company.com",
"street_address": "123 Main St",
"city": "New York",
"state": "NY",
"zip_code": "10001",
"notes": "This is a new company.",
"created_at": "2024-12-14T17:20:10.909Z",
"updated_at": "2024-12-14T17:20:10.909Z"
},
{
"id": 2,
"user_id": 5,
"name": "New Company1",
"website": "www.company1.com",
"street_address": "1231 Main St",
"city": "New York",
"state": "NY",
"zip_code": "10001",
"notes": "This is a new company1.",
"created_at": "2024-12-14T17:37:24.153Z",
"updated_at": "2024-12-14T17:37:24.153Z"
}
]
}
}
}
}
}

```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

- ### **_Important Schema Note_**

  - This branch introduces 2 new tables to our db schema - **roles** and **users_roles** that were generated by Rolify:

    - **roles** table has name, resouce_type and resource_id. Name string is the name of the role and can either be ["admin"] OR ["user"]. Resource type string is an optional polymorphic association that specifies the type of resource the role applies to (company, job, contact).
      - Whenever a user is created, they are automatically assigned a role[:name] of `["user"]`
    - **users_roles** is a join table for the many-to-many relationship between users and roles.

- ## Understanding [JWT(Json Web Token) Gem](https://github.com/jwt/ruby-jwt/blob/main/README.md)

  We now use JSON Web Tokens for user authentication. Here's what to know:

  - ### Key Concepts
    - **Token-Based Authentication**
      - Upon login, a JWT is issued to the registered user.
      - The token must be included in the **Headers** for every authenticated request in Postman.
        - Authorization: Bearer <jwt_token>
      - The token encodes a **payload** that contains:
        - User's id
        - User's role (either "admin" or "user")
        - Tokens expiration time (24 hours after issue)
    - **Changes made in Codebase**
      - **ApplicationController** now has 2 new methods:
        - `authenticate_user` ensures tokens validity and corresponds to a logged-in user.
        - `decoded_token(token)` to extract info from token
        - All controllers will inherit this logic.
      - **SessionsController**
        - Handles login and session creation
        - `#create` action:
          - Verifies user's credentials
          - `generate_token(payload)` generates an encoded JWT using above-mentioned **payload**
          - Sends the token back in the response

- ## Understanding the [Rolify Gem](https://github.com/RolifyCommunity/rolify/blob/master/README.md)

  Rolify simplifies the management of user roles by introducing a flexible, role-based system. This gem created the **roles** and **users_roles** tables.

  - ### Key Concepts

    - When a new user is created, they are automatically assigned the user role.
    - Methods in **user.rb** created as querying and setting shortcuts:
      - `assign_default_role` is called to set a user's role to `:user` upon a new instance of User being created. All new users will get role :user.
      - `is_admin?` and/or `is_user?` queries any user's role
      - `set_role(role_name)` assigns a specific role to a user(e.g `user1.set_role(:admin)` will set a user to the :admin role)
    - For future scalability, polymorphic roles can be scoped to specific users. For example, we can add in a :moderator role in the future that would be an :admin for only the company table. Enabled by resource_type and resource_id fields in **roles** table.

  - ### Usage in Codebase

    - In your models where roles are needed (e.g., User, Company), use: `resourcify` at the top of the class(near validations/relations) to make the model "role-aware" and capable of interacting with Rolify
    - Use above-mentioned methods in **user.rb** to query and set user roles.

  - ### How this affected the Codebase
    - **UsersController** now leverages roles to restrict access. For example, only an :admin can view all users (subject to change, ofc)
    - **ApplicationPolicy** Includes logic to ensure actions are authorized based on roles.
    - Affects RSpec testing to test role-based permitted controller actions (see **index_spec.rb** ln:7 for an example)

- ## Understanding the [Pundit Gem](https://github.com/varvet/pundit/blob/main/README.md)

      Pundit enforces authorization through policy classes and ensures that only authorized users can perform specific actions. To fully understand Pundit, you must understand what a policy is:
      - A policy is a PORO that defines the rules governing what actions a user is authorized to perform on a resource (e.g., User, Job, Company). Each policy corresponds to a model's controller and centralizes the access control logic for that resource.
      - I have set up **UserPolicy** for it's corresponding **UsersController** as a template for all to use. **UserPolicy** restricts which CRUD actions a user can use depending on that user's role. All of **Users** associated request spec files have also been refactored to pass and are a template for you.

      - ### Key Concepts
          - **Policy Classes** as mentioned above define an action a user can take
              - stored in app/policies and inherit from **ApplicationPolicy**
              - Policies are then passed to **ApplicationController** via `  include Pundit::Authorization` ln:2. Remember that all controllers inherit from **ApplicationController** unless explicitly told not to.
          - **Authorization Logic**
              - Authorization is defined in methods corresponding to controller actions (e.g., **create?**, **update?**).
              - **ApplicationPolicy** provides a default template where ALL actions are unauthorized by default.
              - Use **UserPolicy** (and it's associated spec file for testing) as a template for making your controller's policies.
          - **Scoping**
              - Policies include a nested **Scope** class (see **UserPolicy**) to define which records a user can access when retrieving a collection.
      - ### Usage in Codebase
          - Use the `authorize` method IN your controller action code blocks to enforce policy checks (see **UsersController** ln: 5, 15, 21, 28 for examples. Yes, it is THAT easy :))
          - If a user is unauthorized, Pundit raises a `Pundit::NotAuthorizedError` in your console RSpec testing suite.
          - For testing, refer to **user_policy_spec.rb** as a template. Note that ln:3 `subject { described_class }` subject == **UserPolicy**
          - Policies integrate with Rolify to check user roles

      ## In conclusion
          - JWT secures the app by ensuring only authenticated users can access resources.
          - Rolify manages who can act (roles), while Pundit manages what they can do (authorization).
          - Refactoring controllers and policies is critical to aligning with this new system.
          - Ensure all tests are updated to reflect these changes, including controller specs and new policy tests.
          - It is up to you, as you develop to keep in mind what actions users are authorized to take.  :Admin role users should be authorized to do anything.

  <p align="right">(<a href="#readme-top">back to top</a>)</p>

# Contributors

**Banks, Charles**

- [Github](https://github.com/DRIF7ER)
- [LinkedIn](https://www.linkedin.com/in/charles-t-banks-jr-6b982b152//)

**Bleggi, Jillian**

- [Github](https://github.com/jbleggi)
- [LinkedIn](https://www.linkedin.com/in/jillianbleggi/)

**Bloom, Stefan**

- [Github](https://github.com/stefanjbloom)
- [LinkedIn](https://www.linkedin.com/in/stefanjbloom/)

**Cardona, Danielle**

- [Github](https://github.com/dcardona23)
- [LinkedIn](https://www.linkedin.com/in/danielle-cardona-se/)

**Chirchirillo, Joe**

- [Github](https://github.com/jchirch)
- [LinkedIn](https://www.linkedin.com/in/joechirchirillo/)

**Cirbo, Candice**

- [Github](https://github.com/ccirbo)
- [LinkedIn](https://www.linkedin.com/in/candicecirbo/)

**Cochran, James**

- [Github](https://github.com/James-Cochran)
- [LinkedIn](https://www.linkedin.com/in/james-cochran-/)

**Croy, Lito**

- [Github](https://github.com/litobot)
- [LinkedIn](https://www.linkedin.com/in/litocroy/)

**Davalos, Joel**

- [Github](https://github.com/jdavalos98)
- [LinkedIn](https://www.linkedin.com/in/joeldavalos/)

**Delaney, Kyle**

- [Github](https://gist.github.com/kylomite)
- [LinkedIn](https://www.linkedin.com/in/kylehamptondelaney/)

**De La Rosa, Melchor**

- [Github](https://github.com/MDelarosa1993)
- [LinkedIn](https://www.linkedin.com/in/melchordelarosa/)

**Fallenius, Karl Frederick**

- [Github](https://github.com/SmilodonP)
- [LinkedIn](https://www.linkedin.com/in/karlfallenius)

**Fox, Will**

- [Github](https://github.com/willfox0409)
- [LinkedIn](https://www.linkedin.com/in/williammacdonaldfox)

**Freyr, Rig**

- [Github](https://github.com/ontruster74)
- [LinkedIn](https://www.linkedin.com/in/rigfreyr)

**Galvin, Shane**

- [Github](https://github.com/sgalvin36)
- [LinkedIn](https://www.linkedin.com/in/shane-galvin36/)

**Green, Beverly**

- [Github](https://github.com/bevgreen)
- [LinkedIn](https://www.linkedin.com/in/beverlylouisegreen/)

**Haefling, Matt**

- [Github](https://github.com/mhaefling)
- [LinkedIn](www.linkedin.com/in/matthew-haefling)

**Hill, John**

- [Github](https://github.com/jphill19)
- [LinkedIn](https://www.linkedin.com/in/johnpierrehill/)

**Hotaling, Marshall**

- [Github](https://github.com/marshallhotaling)
- [LinkedIn](https://www.linkedin.com/in/marshall-hotaling-7b52a8304/)

**Inman, Jacob**

- [Github](https://github.com/jinman14)
- [LinkedIn](https://www.linkedin.com/in/jacobinman/)

**Kendall, Mark**

- [Github](https://github.com/mkendall42)
- [LinkedIn](https://www.linkedin.com/in/markkendall496/)

**Knapp, Paul**

- [Github](https://github.com/Paul-Knapp)
- [LinkedIn](www.linkedin.com/in/paul-m-knapp)

**Lynch, Devlin**

- [Github](https://github.com/devklynch)
- [LinkedIn](https://www.linkedin.com/in/devlin-lynch/)

**Macur, Jim**

- [Github](https://github.com/jimmacur)
- [LinkedIn](https://www.linkedin.com/in/jimmacur/)

**Manning, Terra**

- [Github](https://github.com/TDManning)
- [LinkedIn](https://www.linkedin.com/in/terra-manning/)

**McKee, Sebastian**

- [Github](https://github.com/0nehundr3d)
- [LinkedIn](https://www.linkedin.com/in/sebastianmckee/)

**Messersmith, Renee**

- [Github](https://github.com/reneemes)
- [LinkedIn](https://www.linkedin.com/in/reneemessersmith/)

**Newland, Kevin**

- [Github](https://github.com/kevin-newland)
- [LinkedIn](https://www.linkedin.com/in/kevin-newland/)

**O'Brien, Michael**

- [Github](https://github.com/MiTOBrien)
- [LinkedIn](https://www.linkedin.com/in/michaelobrien67/)

**O'Leary, Ryan**

- [Github](https://github.com/ROlearyPro)
- [LinkedIn](https://www.linkedin.com/in/ryan-o-leary-6a963b211/)

**Pintozzi, Erin - (Project Manager)**

- [Github](https://github.com/epintozzi)
- [LinkedIn](https://www.linkedin.com/in/erin-pintozzi/)

**Riley, Alora**

- [Github](https://github.com/aloraalee)
- [LinkedIn](https://www.linkedin.com/in/alorariley/)

**Salazar, Kaelin**

- [Github](https://github.com/kaelinpsalazar)
- [LinkedIn](https://www.linkedin.com/in/kaelin-salazar/)

**Sommers, Jono**

- [Github](https://github.com/JonoSommers)
- [LinkedIn](https://www.linkedin.com/in/jonosommers/)

**Vasquez, Natasha**

- [Github](https://github.com/nvnatasha)
- [LinkedIn](https://www.linkedin.com/in/natasha-vasquez/)

**Verrill, Seth**

- [Github](https://github.com/sethverrill)
- [LinkedIn](https://www.linkedin.com/in/sethverrill/)

**Wallace, Wally**

- [Github](https://github.com/wally-yawn)
- [LinkedIn](https://www.linkedin.com/in/wally--wallace/)

**Ward, Elysa**

- [Github](https://github.com/elysableu)
- [LinkedIn](https://www.linkedin.com/in/elysa-ward/)

**Weiland, Kristin**

- [Github](https://github.com/KMPWeiland)
- [LinkedIn](https://www.linkedin.com/in/kristinweiland/)

**Willett, Bryan**

- [Github](https://github.com/bwillett2003)
- [LinkedIn](https://www.linkedin.com/in/bryan--willett/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
```
