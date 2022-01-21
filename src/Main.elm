module Main exposing (..)

import Api exposing (..)
import Browser
import Dict
import Html.Styled exposing (toUnstyled)
import Model exposing (..)
import RemoteData exposing (RemoteData(..))
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
            ( { model | users = RemoteData.fromResult result }, Cmd.none )

        UpsertUserResponse result ->
            case ( result, model.users ) of
                ( Ok ( id, user ), Success theUsers ) ->
                    ( { model | users = Success (theUsers |> Dict.insert id user), underEdit = NotEditing }, Cmd.none )

                ( Err errs, _ ) ->
                    ( { model | errors = errs :: model.errors }, Cmd.none )

                _ ->
                    ( model, fetchUsers )

        DeleteUserResponse result ->
            case ( result, model.users ) of
                ( Ok ( id, _ ), Success theUsers ) ->
                    ( { model | users = Success (theUsers |> Dict.remove id), underEdit = NotEditing }, Cmd.none )

                ( Err errs, _ ) ->
                    ( { model | errors = errs :: model.errors }, Cmd.none )

                _ ->
                    ( model, fetchUsers )

        Edit underEdit ->
            ( { model | underEdit = underEdit }, Cmd.none )

        PostUser user ->
            ( model, createUser user )

        PutUser id user ->
            ( model, updateUser ( id, user ) )

        IntendDeleteUser confirmingDelete ->
            ( { model | confirmingDelete = confirmingDelete }, Cmd.none )

        DeleteUser id ->
            ( { model | confirmingDelete = Nothing }, deleteUser id )

        DismissLastError ->
            case model.errors of
                [] ->
                    ( model, Cmd.none )

                _ :: errors ->
                    ( { model | errors = errors }, Cmd.none )
