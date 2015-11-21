module Main where

import Effects exposing (Effects)
import Html exposing (Html)
import Html.Attributes
import Signal exposing (Address)
import StartApp exposing(App)

import Components.Form as Form
import Components.Input as Input

type alias Model =
  { form: Form.Model
  }

init: (Model, Effects Action)
init =
  let
    fields =
      [ ("amount", "Amount")
      , ("num_years", "Number of years")
      , ("apr", "APR (%)")
      ]

    (form, formFx) =
      Form.init fields
  in
    (Model form, Effects.map FormAction formFx)

type Action
  = FormAction Form.Action

update: Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    FormAction formAction ->
      let
        (newForm, fx) = Form.update formAction model.form
      in
        ({ model | form = newForm }, Effects.map FormAction fx)

view: Address Action -> Model -> Html
view address model =
  let
    formAddress =
      Signal.forwardTo address FormAction
  in
    Html.div
      [ Html.Attributes.class "container" ]
      [ Html.h1 [] [ Html.text "Mortgage Calculator" ]
      , Form.view formAddress model.form
      ]

app : App Model
app = StartApp.start { init = init, view = view, update = update, inputs = [] }

main : Signal Html
main = app.html
