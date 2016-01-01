module Mortgage where

import Effects exposing (Effects)
import Html exposing (Html, Attribute)
import Html.Attributes
import Html.Events
import Signal exposing (Address)
import StartApp exposing (App)

type alias Model
  = { amount: String
    , numYears: String
    , apr: String
    }

type Action
  = UpdateAmount String
  | UpdateNumYears String
  | UpdateApr String
  | Submit

init: (Model, Effects Action)
init =
  let
    model =
      { amount = ""
      , numYears = ""
      , apr = ""
      }
  in
    (model, Effects.none)

update: Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    UpdateAmount amount ->
      ({ model | amount = amount }, Effects.none)
    UpdateNumYears numYears ->
      ({ model | numYears = numYears }, Effects.none)
    UpdateApr apr ->
      ({ model | apr = apr }, Effects.none)
    Submit ->
      (model, Effects.none)

view: Address Action -> Model -> Html
view address model =
  let
    inputLabel id label =
      Html.label
        [ Html.Attributes.for id
        , Html.Attributes.class "col-sm-4 control-label"
        ]
        [ Html.text label ]

    inputField id action value =
      let
        onInput address =
          let
            toMessage address value =
              Signal.message address (action value)
          in
            Html.Events.on "input" Html.Events.targetValue (toMessage address)
      in
        Html.input
          [ Html.Attributes.id id
          , Html.Attributes.class "form-control"
          , Html.Attributes.type' "number"
          , Html.Attributes.required True
          , Html.Attributes.value value
          , onInput address
          ]
          [ ]

    input id label action value =
      Html.div
        [ Html.Attributes.class "form-group" ]
        [ inputLabel id label,
          Html.div
          [ Html.Attributes.class "col-sm-8" ]
          [ inputField id action value ]
        ]

    formView =
      Html.form
        [ Html.Attributes.class "form-horizontal" ]
        [ input "amount" "Amount" UpdateAmount model.amount
        , input "num_years" "Number of years" UpdateNumYears model.numYears
        , input "apr" "APR (%)" UpdateApr model.apr
        ]

    button =
      Html.button
        [ Html.Attributes.type' "submit"
        , Html.Attributes.class "btn btn-primary"
        , Html.Events.onClick address Submit
        ]
        [ Html.text "Submit" ]

    submitView =
      Html.div
        [ Html.Attributes.class "form-group" ]
        [ Html.div
          [ Html.Attributes.class "col-sm-offset-4 col-sm-8" ]
          [ button ]
        ]

  in
    Html.div
      [ Html.Attributes.class "container" ]
      [ Html.h1 [] [ Html.text "Mortgage Calculator" ]
      , formView
      , submitView
      ]

app : App Model
app = StartApp.start { init = init, view = view, update = update, inputs = [] }

main : Signal Html
main = app.html
