# Elm Challenge for the Users Management Squad

Your task is to write a CRUD application for a `users` API with the following requirements and features:

* The app must be able to live on a part of the page potentially with other applications side by side.
* The app must be written in Elm.
* The app must allow listing users on an appropriate url.
* The app must allow creating a singular user on an appropriate url.
* The app must allow editing a singular user on an appropriate url.
* Share the code between the create and edit view as much as possible.
* The app must allow deleting a singular user. Being a dangerous action this requires a confirmation from the user which should be displayed in a modal view.
* As a user I must be able to reload the application on any of the urls and see the same view.
* Structure and style the application in whatever way you see fit, it can be very simple. There's only one requirement. On the listing page, display users in a gallery style where multiple users are displayed next to each other in medallions of reasonable width and the others are displayed in rows below. The gallery must adapt to the browser width so that the user does not have to scroll horizontally.
* Provide such tests that you think are reasonable.
* Handle and properly surface transient and error states of every API request.
* For simplicity's sake you can ignore both authentication and authorization.
* If you do not have time to implement any feature or requirement, comment about it directly in code and explain how you would otherwise proceed.
* Adding your ideas to improve the users' experience is more than welcome.

## Bonus points:
* The app should be easy to setup and use even on a new machine and by a new developer.
* The app should be ideally OS agnostic.
* Provide production-grade build pipeline.

## The API spec

The users API is a REST JSON API, the specification of which you can find below. Your solution will be manually tested on our implementation of this API. For the purposes of development, feel free to mock it away.

* GET /users

Returns a `200 OK` with example payload:

```json
{
  "users": [
    {
      "id": 1,
      "first_name": "John",
      "last_name": "Doe",
      "elm_skill": 2
    }
  ]
}
```

* GET /users/:id

Returns a `200 OK` with example payload:

```json
{
  "user": {
    "id": 1,
    "first_name": "John",
    "last_name": "Doe",
    "elm_skill": 2
  }
}
```

* POST /users

With example payload:

```json
{
  "user": {
    "first_name": "John",
    "last_name": "Doe",
    "elm_skill": 2
  }
}
```

Returns either a `201 Created` with:

```json
{
  "user": {
    "id": 1,
    "first_name": "John",
    "last_name": "Doe",
    "elm_skill": 2
  }
}
```

Or a `422 Unprocessable Entity` with:

```json
{
  "errors": {
    "user": {
      "first_name": ["too short"],
      "last_name": ["invalid"]
    }
  }
}
```

For simplicity display all the errors returned by the backend as comma-separated strings. Do not assume any validation, let the backend decide.


* PUT /users/:id

With example payload:

```json
{
  "user": {
    "first_name": "John",
    "last_name": "Doe",
    "elm_skill": 2
  }
}
```

Returns either a `200 OK` with:

```json
{
  "user": {
    "id": 1,
    "first_name": "John",
    "last_name": "Doe",
    "elm_skill": 2
  }
}
```

Or a `422 Unprocessable Entity` with:

```json
{
  "errors": {
    "user": {
      "first_name": ["too short"],
      "last_name": ["invalid"]
    }
  }
}
```

* DELETE /users/:id

Returns a `200 OK` with example payload:

```json
{
  "user": {
    "id": 1,
    "first_name": "John",
    "last_name": "Doe",
    "elm_skill": 2
  }
}
```

Good luck potential colleague! See you on your PR's code review!
