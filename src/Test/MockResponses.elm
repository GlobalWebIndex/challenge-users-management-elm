module Test.MockResponses exposing (..)

import Dict
import Http

{- To test HTTP responses with these mocks, replace `Http.expectStringResponse`
with `Http.Mock.expectStringResponse mockResponse` from one of the mock responses
below, or a similar one. -}

mockGoodUsersResponse : Http.Response String
mockGoodUsersResponse =
    Http.GoodStatus_
        { url = "https://configure"
        , statusCode = 422
        , statusText = "OK"
        , headers = Dict.fromList []
        }
        """{
            "users": [
                {
                "id": 1,
                "first_name": "John",
                "last_name": "Doe",
                "elm_skill": 2
                },

                {
                "id": 2,
                "first_name": "Emmanuel",
                "last_name": "Melville",
                "elm_skill": 1
                },

                {
                "id": 3,
                "first_name": "Klaus",
                "last_name": "Lohengrin",
                "elm_skill": 4
                },

                {
                "id": 4,
                "first_name": "Jane",
                "last_name": "Doe",
                "elm_skill": 3
                },

                {
                "id": 5,
                "first_name": "Titan",
                "last_name": "Niobe",
                "elm_skill": 1
                },

                {
                "id": 6,
                "first_name": "Magnetar",
                "last_name": "Homuncule",
                "elm_skill": 3
                }
            ]
        }"""


mockBadUserResponse : Http.Response String
mockBadUserResponse =
    Http.BadStatus_
        { url = "https://configure"
        , statusCode = 422
        , statusText = "Unprocessable Entity"
        , headers = Dict.fromList []
        }
        """{
            "errors": {
                "user": {
                "first_name": ["too short"],
                "last_name": ["invalid"]
                }
            }
        }"""


mockGoodUserResponse : Http.Response String
mockGoodUserResponse =
    Http.GoodStatus_
        { url = "https://configure"
        , statusCode = 200
        , statusText = "OK"
        , headers = Dict.fromList []
        }
        """{
            "user": {
                "id": 2,
                "first_name": "Beee",
                "last_name": "Booo",
                "elm_skill": 2
            }
        }"""
