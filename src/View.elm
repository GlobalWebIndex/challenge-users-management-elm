module View exposing (viewStyled)

import Css exposing (..)
import Dict exposing (Dict)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, placeholder, value)
import Html.Styled.Events exposing (onClick, onInput)
import Model exposing (..)
import RemoteData exposing (RemoteData(..))


viewStyled : Model -> Html Msg
viewStyled model =
    div [] [ viewRemoteData "list of users" model.users (viewUsers model) ]


viewRemoteData : String -> RemoteData (List String) a -> (a -> Html Msg) -> Html Msg
viewRemoteData elementName rdata viewSuccess =
    case rdata of
        NotAsked ->
            text ("Initializing " ++ elementName)

        Loading ->
            text ("Loading " ++ elementName)

        Failure errors ->
            text ("Error loading " ++ elementName ++ ": " ++ String.join ", " errors)

        Success x ->
            viewSuccess x


viewUsers : Model -> Dict Int User -> Html Msg
viewUsers ({ underEdit } as model) users =
    let
        theUsers =
            Dict.toList users

        medallions =
            (List.take 3 theUsers |> List.map (viewUser medallion underEdit)) ++ [ viewCreateUserMedallion underEdit ]

        medallionsArea =
            div
                [ css
                    [ property "display" "grid"
                    , property "grid-template-columns" "repeat(auto-fill, minmax(min(100%, 180px), 1fr))"
                    , property "grid-gap" "8px"
                    , padding (px 8)
                    , borderBottom2 (px 1) solid
                    ]
                ]
                medallions

        rows =
            List.drop 3 theUsers |> List.map (viewUser row underEdit)
    in
    div [] (viewFooter model :: medallionsArea :: rows)


viewFooter : Model -> Html Msg
viewFooter { confirmingDelete, errors, underEdit } =
    case ( confirmingDelete, errors, underEdit ) of
        ( Just ( id, { firstName, lastName } ), _, _ ) ->
            modalFooter [ css [ backgroundColor (hex "eaa") ] ]
                [ text ("Do you want to delete " ++ firstName ++ " " ++ lastName ++ "? ")
                , button [ onClick (DeleteUser id) ] [ text "yes" ]
                , button [ onClick (IntendDeleteUser Nothing) ] [ text "no" ]
                ]

        ( Nothing, errs :: _, _ ) ->
            footer [ css [ backgroundColor (hex "eaa") ] ]
                [ text ("Error: " ++ String.join ", " errs)
                , button [ onClick DismissLastError ] [ text "dismiss" ]
                ]

        ( Nothing, [], NewUser user ) ->
            footer [ css [ backgroundColor (hex "aea") ] ]
                [ button [ onClick (PostUser user) ] [ text "save" ]
                , button [ onClick (Edit NotEditing) ] [ text "discard" ]
                ]

        ( Nothing, [], Id id user ) ->
            footer [ css [ backgroundColor (hex "eea") ] ]
                [ button [ onClick (PutUser id user) ] [ text "save" ]
                , button [ onClick (Edit NotEditing) ] [ text "discard" ]
                , button [ onClick (IntendDeleteUser (Just ( id, user ))) ] [ text "delete" ]
                ]

        _ ->
            footer [] []


viewCreateUserMedallion : UnderEdit -> Html Msg
viewCreateUserMedallion underEdit =
    case underEdit of
        NewUser user ->
            medallion [ css [ backgroundColor (hex "aea") ] ] (inputs user (Edit << NewUser))

        _ ->
            medallion [ css [ cursor pointer ], onClick (Edit (NewUser initUser)) ] [ span [ css [ fontSize (rem 2) ] ] [ text "➕" ] ]


viewUser : (List (Attribute Msg) -> List (Html Msg) -> Html Msg) -> UnderEdit -> ( Int, User ) -> Html Msg
viewUser wrapper underEdit ( id, { firstName, lastName, elmSkill } as user ) =
    let
        default =
            wrapper [ css [ cursor pointer ], onClick (Edit (Id id user)) ] (texts user)
    in
    case underEdit of
        Id id_ user_ ->
            if id == id_ then
                wrapper [ css [ backgroundColor (hex "eea") ] ] (inputs user_ (Edit << Id id))

            else
                default

        _ ->
            default


medallion : List (Attribute msg) -> List (Html msg) -> Html msg
medallion extraAttrs =
    div
        (css
            [ borderRadius (pct 50)
            , border2 (px 1) solid
            , displayFlex
            , flexDirection column
            , alignItems center
            , justifyContent center
            , property "align-content" "center"
            , property "aspect-ratio" "1"
            ]
            :: extraAttrs
        )


row : List (Attribute msg) -> List (Html msg) -> Html msg
row extraAttrs =
    div (css [ borderBottom2 (px 1) solid, displayFlex, flexDirection column, padding (px 2) ] :: extraAttrs)


footer : List (Attribute msg) -> List (Html msg) -> Html msg
footer extraAttrs =
    div (css [ displayFlex, alignItems center, padding (px 8), position fixed, left (px 0), right (px 0), bottom (px 0), height (px 28) ] :: extraAttrs)


modalFooter : List (Attribute msg) -> List (Html msg) -> Html msg
modalFooter extraAttrs elems =
    div []
        [ div [ css [ position fixed, opacity (num 0.5), backgroundColor (hex "000"), left (px 0), right (px 0), bottom (px 0), top (px 0) ] ] []
        , footer extraAttrs elems
        ]


inputs : User -> (User -> Msg) -> List (Html Msg)
inputs ({ firstName, lastName, elmSkill } as user) toMsg =
    [ div []
        [ input [ css [ width (px 72) ], value firstName, placeholder "first name", onInput (\new -> { user | firstName = new } |> toMsg) ] []
        , input [ css [ width (px 72) ], value lastName, placeholder "last name", onInput (\new -> { user | lastName = new } |> toMsg) ] []
        ]
    , div []
        [ span [] [ text "Elm skill: " ]
        , button [ onClick ({ user | elmSkill = clamp 1 5 (elmSkill - 1) } |> toMsg) ] [ text "-" ]
        , span [] [ text (" " ++ String.fromInt elmSkill ++ " ") ]
        , button [ onClick ({ user | elmSkill = clamp 1 5 (elmSkill + 1) } |> toMsg) ] [ text "+" ]
        ]
    ]


texts : User -> List (Html Msg)
texts { firstName, lastName, elmSkill } =
    [ span [] [ text (firstName ++ " " ++ lastName) ]
    , div []
        [ span [] [ text "Elm skill: " ]
        , span [] [ text (String.fromInt elmSkill) ]
        ]
    ]
