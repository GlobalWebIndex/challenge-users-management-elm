module Decoders exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)
import Model exposing (..)


rawUser : Decoder User
rawUser =
    map3 User
        (field "first_name" string)
        (field "last_name" string)
        (field "elm_skill" int)


user : Decoder User
user =
    field "user" rawUser


userWithId : Decoder ( Int, User )
userWithId =
    field "id" int
        |> andThen (\id -> rawUser |> map (Tuple.pair id))


users : Decoder (Dict Int User)
users =
    field "users" (list userWithId |> map Dict.fromList)


errors : Decoder (List String)
errors =
    at [ "errors", "user" ] (dict (list string))
        |> map (Dict.values >> List.concat)
