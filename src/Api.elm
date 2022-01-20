module Api exposing (..)

import Decoders
import Http
import Http.Detailed exposing (..)
import Json.Decode exposing (Decoder)
import Model exposing (..)

fetchUsers : Cmd Msg
fetchUsers =
    Http.get
        { url = "https://configure"
        , expect = Http.expectStringResponse GetUsersResponse (responseToPayload Decoders.users)
        }


responseToPayload : Decoder a -> Http.Response String -> Result (List String) a
responseToPayload decoder response =
    case responseToJson decoder response of
        Ok (_, body) ->
            Ok body

        Err (BadStatus { statusCode } body) ->
            if statusCode == 422 then
                case Json.Decode.decodeString Decoders.errors body of
                    Ok errors ->
                        Err errors

                    Err _ ->
                        Err ["Error decoding error response body. Please try again later."]
            else
                Err ["Unexpected status code. Please try again later."]

        Err (BadUrl _) ->
            Err ["Misconfigured url in application. Please refresh the page and try again much later."]

        Err Timeout ->
            Err ["Connection to server timed out. Please try again later."]

        Err NetworkError ->
            Err ["A network error occurred. Please try again later."]

        Err (BadBody _ _ _) ->
            Err ["Error decoding response body. Please try again later."]
