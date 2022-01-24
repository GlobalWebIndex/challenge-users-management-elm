module Encoders exposing (..)

import Json.Encode exposing (..)
import Model exposing (..)


userFields : User -> List ( String, Value )
userFields { firstName, lastName, elmSkill } =
    [ ( "first_name", string firstName )
    , ( "last_name", string lastName )
    , ( "elm_skill", int elmSkill )
    ]


user : User -> Value
user =
    object << userFields


userId : Int -> Value
userId =
    int


userWithId : ( Int, User ) -> Value
userWithId ( id, u ) =
    object (( "id", int id ) :: userFields u)
