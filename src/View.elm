module View exposing (viewStyled)

import Css exposing (..)
import Html.Styled exposing (..)
import Model exposing (..)


viewStyled : Model -> Html Msg
viewStyled model =
    div [] [text (Debug.toString model)]
