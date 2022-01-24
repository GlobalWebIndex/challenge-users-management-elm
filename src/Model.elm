module Model exposing (..)

import Dict exposing (Dict)
import RemoteData exposing (RemoteData(..))


type alias Model =
    { users : RemoteData (List String) (Dict Int User)
    , underEdit : UnderEdit
    , errors : List (List String)
    , confirmingDelete : Maybe ( Int, User )
    }


initModel : Model
initModel =
    { users = NotAsked
    , underEdit = NotEditing
    , errors = []
    , confirmingDelete = Nothing
    }


type alias User =
    { firstName : String
    , lastName : String
    , elmSkill : Int
    }


initUser : User
initUser =
    { firstName = ""
    , lastName = ""
    , elmSkill = 3
    }


type UnderEdit
    = NewUser User
    | Id Int User
    | NotEditing


type Msg
    = GetUsersResponse (Result (List String) (Dict Int User))
    | UpsertUserResponse (Result (List String) ( Int, User ))
    | DeleteUserResponse (Result (List String) ( Int, User ))
    | Edit UnderEdit
    | PostUser User
    | PutUser Int User
    | IntendDeleteUser (Maybe ( Int, User ))
    | DeleteUser Int
    | DismissLastError
