module Components.Input where

import Effects exposing (Effects)
import Html exposing (Html, Attribute)
import Html.Attributes
import Html.Events
import Signal exposing (Address)

type alias Model =
  { id : String
  , label : String
  , value : String
  }

init: (String, String) -> (Model, Effects Action)
init (id, label) =
  (Model id label "", Effects.none)

type Action =
  SetValue String

update: Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    SetValue value ->
      ({ model | value = value }, Effects.none)

view: Address Action -> Model -> Html
view address model =
  let
    inputLabel =
      Html.label
        [ Html.Attributes.for model.id
        , Html.Attributes.class "col-sm-4 control-label"
        ]
        [ Html.text model.label ]

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
          [ Html.Attributes.id model.id
          , Html.Attributes.class "form-control"
          , Html.Attributes.type' "number"
          , Html.Attributes.required True
          , Html.Attributes.value model.value
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
