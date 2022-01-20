module Main exposing (..)

import Api exposing (..)
import Browser
import Html.Styled exposing (toUnstyled)
import Model exposing (..)
import RemoteData exposing (fromResult)
import Result
import Task
import View exposing (viewStyled)


main : Program () Model Msg
main =
    Browser.element
        { init = always ( initModel, Cmd.batch [ fetchUsers ] )
        , update = update
        , subscriptions = always Sub.none
        , view = viewStyled >> toUnstyled
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetUsersResponse result ->
            ( { model | users = fromResult result }, Cmd.none )

        GetUserResponse result ->
            ( model, Cmd.none )
