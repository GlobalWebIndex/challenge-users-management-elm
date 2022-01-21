module Api exposing (..)

import Decoders
import Dict exposing (Dict)
import Encoders
import Http
import Http.Detailed exposing (Error(..))
import Json.Decode exposing (Decoder, decodeString)
import Model exposing (..)


fetchUsers : Cmd Msg
fetchUsers =
    Http.get
        { url = "https://configure"
        , expect =
            Http.expectStringResponse
                GetUsersResponse
                (responseToPayload Dict.empty Decoders.users)
        }


createUser : User -> Cmd Msg
createUser user =
    Http.post
        { url = "https://configure"
        , expect =
            Http.expectStringResponse
                UpsertUserResponse
                (responseToPayload (Dict.fromList [ ( 422, Decoders.userUpsertErrors ) ]) Decoders.userResponse)
        , body = Http.jsonBody (Encoders.user user)
        }


updateUser : ( Int, User ) -> Cmd Msg
updateUser ( id, user ) =
    Http.request
        { method = "PUT"
        , headers = []
        , url = "https://configure"
        , expect =
            Http.expectStringResponse
                UpsertUserResponse
                (responseToPayload (Dict.fromList [ ( 422, Decoders.userUpsertErrors ) ]) Decoders.userResponse)
        , body = Http.jsonBody (Encoders.userWithId ( id, user ))
        , timeout = Nothing
        , tracker = Nothing
        }


deleteUser : Int -> Cmd Msg
deleteUser id =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "https://configure"
        , expect =
            Http.expectStringResponse
                DeleteUserResponse
                (responseToPayload Dict.empty Decoders.userResponse)
        , body = Http.jsonBody (Encoders.userId id)
        , timeout = Nothing
        , tracker = Nothing
        }


responseToPayload : Dict Int (Decoder (List String)) -> Decoder a -> Http.Response String -> Result (List String) a
responseToPayload errorStatusDecoders successDecoder response =
    case Http.Detailed.responseToJson successDecoder response of
        Ok ( _, body ) ->
            Ok body

        Err (BadStatus { statusCode } body) ->
            case errorStatusDecoders |> Dict.get statusCode of
                Just errorDecoder ->
                    case decodeString errorDecoder body of
                        Ok errors ->
                            Err errors

                        Err _ ->
                            Err [ "Error decoding error response body. Please try again later." ]

                Nothing ->
                    Err [ "Unexpected status code. Please try again later." ]

        Err (BadUrl _) ->
            Err [ "Misconfigured url in application. Please refresh the page and try again much later." ]

        Err Timeout ->
            Err [ "Connection to server timed out. Please try again later." ]

        Err NetworkError ->
            Err [ "A network error occurred. Please try again later." ]

        Err (BadBody _ _ _) ->
            Err [ "Error decoding response body. Please try again later." ]
