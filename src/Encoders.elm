module Encoders exposing (..)

import Json.Encode exposing (..)
import Model exposing (..)


userFields : User -> List (String, Value)
userFields u =
    [ ( "first_name", string u.firstName )
    , ( "last_name", string u.lastName )
    , ( "elm_skill", int u.elmSkill )
    ]

user : User -> Value
user u =
    object (userFields u)


userWithId : (Int, User) -> Value
userWithId (id, u) =
    object (("id", int id) :: userFields u)
