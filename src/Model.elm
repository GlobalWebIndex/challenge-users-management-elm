module Model exposing (..)

import Dict exposing (Dict)
import RemoteData exposing (RemoteData(..))


type alias Model =
    { users : RemoteData (List String) (Dict Int User)
    }


initModel : Model
initModel =
    { users = NotAsked }


type alias User =
    { firstName : String
    , lastName : String
    , elmSkill : Int
    }


type Msg
    = GetUsersResponse (Result (List String) (Dict Int User))
    | GetUserResponse (Result (List String) User)
