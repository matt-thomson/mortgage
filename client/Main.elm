module Main where

import Effects exposing (Effects)
import Html exposing (Html)
import Html.Attributes
import Signal exposing (Address)
import StartApp exposing(App)

import Components.Form as Form
import Components.Submit as Submit

type alias Model =
  { form: Form.Model
  , submit: Submit.Model
  }

init: (Model, Effects Action)
init =
  let
    (form, formFx) =
      Form.init

    (submit, submitFx) =
      Submit.init

    fx =
      Effects.batch
        [ Effects.map FormAction formFx
        , Effects.map SubmitAction submitFx
        ]
  in
    (Model form submit, fx)

type Action
  = FormAction Form.Action
  | SubmitAction Submit.Action

update: Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    FormAction formAction ->
      let
        (newForm, fx) = Form.update formAction model.form
      in
        ({ model | form = newForm }, Effects.map FormAction fx)

    SubmitAction submitAction ->
      let
        (newSubmit, fx) = Submit.update submitAction model.submit
      in
        ({ model | submit = newSubmit }, Effects.map SubmitAction fx)

view: Address Action -> Model -> Html
view address model =
  let
    formAddress =
      Signal.forwardTo address FormAction
    submitAddress =
      Signal.forwardTo address SubmitAction
  in
    Html.div
      [ Html.Attributes.class "container" ]
      [ Html.h1 [] [ Html.text "Mortgage Calculator" ]
      , Form.view formAddress model.form
      , Submit.view submitAddress model.submit
      ]

app : App Model
app = StartApp.start { init = init, view = view, update = update, inputs = [] }

main : Signal Html
main = app.html
