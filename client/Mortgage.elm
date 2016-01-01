module Mortgage where

import Api
import Effects exposing (Effects)
import Html exposing (Html, Attribute)
import Html.Attributes
import Html.Events
import Signal exposing (Address)
import StartApp exposing (App)
import String
import Task

type alias Model
  = { amount: String
    , numYears: String
    , apr: String
    , response: Result String Api.Response
    }

type Action
  = UpdateAmount String
  | UpdateNumYears String
  | UpdateApr String
  | Submit
  | HandleResponse (Result String Api.Response)

init: (Model, Effects Action)
init =
  let
    model =
      { amount = ""
      , numYears = ""
      , apr = ""
      , response = Err ""
      }
  in
    (model, Effects.none)

request: Model -> Result String Api.Request
request model =
  (String.toInt model.amount
    `Result.andThen` \amount -> String.toInt model.numYears
    `Result.andThen` \numYears -> String.toFloat model.apr
    |> Result.map (\apr -> { amount = amount, num_years = numYears, apr = apr }))

update: Action -> Model -> (Model, Effects Action)
update action model =
  let
    fetchStats =
      Task.fromResult (request model) `Task.andThen` Api.getStats
        |> Task.toResult
        |> Task.map HandleResponse
  in
    case action of
      UpdateAmount amount ->
        ({ model | amount = amount }, Effects.none)
      UpdateNumYears numYears ->
        ({ model | numYears = numYears }, Effects.none)
      UpdateApr apr ->
        ({ model | apr = apr }, Effects.none)
      Submit ->
        (model, Effects.task fetchStats)
      HandleResponse response ->
        ({ model | response = response }, Effects.none)

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

    responseText =
      case model.response of
        Ok response ->
          let
            round x = (x * 100 |> floor |> toFloat) / 100.0
            monthlyRepayment = round response.stats.monthly_repayment
          in
            (String.append "Monthly repayment: £" (toString monthlyRepayment))
        Err err ->
          err

    responseView =
      Html.div
        [ Html.Attributes.class "row" ]
        [ Html.div
          [ Html.Attributes.class "col-sm-offset-4 col-sm-8" ]
          [ Html.strong [] [ Html.text responseText ] ]
        ]

  in
    Html.div
      [ Html.Attributes.class "container" ]
      [ Html.h1 [] [ Html.text "Mortgage Calculator" ]
      , formView
      , submitView
      , responseView
      ]

app : App Model
app = StartApp.start { init = init, view = view, update = update, inputs = [] }

main : Signal Html
main = app.html

port tasks : Signal (Task.Task Effects.Never ())
port tasks =
    app.tasks
