module Components.Input where

import Html exposing (Html, Attribute)
import Html.Attributes
import Html.Events
import Signal exposing (Address)

type alias State =
  { id : String
  , label : String
  , value : String
  }

init: String -> String -> State
init id label =
  { id = id
  , label = label
  , value = ""
  }

type Action =
  SetValue String

update: Action -> State -> State
update action state =
  case action of
    SetValue value ->
      { state | value <- value }

view: Address Action -> State -> Html
view address state =
  let
    inputLabel =
      Html.label
        [ Html.Attributes.for state.id
        , Html.Attributes.class "col-sm-4 control-label"
        ]
        [ Html.text state.label ]

    inputField =
      let
        onInput address =
          let
            toMessage address value =
              Signal.message address (SetValue value)
          in
            Html.Events.on "input" Html.Events.targetValue (toMessage address)
      in
        Html.input
          [ Html.Attributes.id state.id
          , Html.Attributes.class "form-control"
          , Html.Attributes.type' "number"
          , Html.Attributes.required True
          , Html.Attributes.value state.value
          , onInput address
          ]
          [ ]
  in
    Html.div
      [ Html.Attributes.class "form-group" ]
      [ inputLabel,
        Html.div
        [ Html.Attributes.class "col-sm-8" ]
        [ inputField ]
      ]
